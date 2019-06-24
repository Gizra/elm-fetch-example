module Backend.Item.Update exposing (update)

import AssocList as Dict
import Backend.Entities exposing (fromEntityId)
import Backend.Item.Decode exposing (decodeItem, decodeItemIds)
import Backend.Item.Model exposing (Msg(..))
import Backend.Item.Utils
import Backend.Model exposing (ModelBackend)
import Backend.Types exposing (BackendReturn)
import Error.Utils exposing (maybeHttpError, noError)
import HttpBuilder exposing (withExpectJson)
import RemoteData


update : Msg -> ModelBackend -> BackendReturn Msg
update msg model =
    let
        noChange =
            BackendReturn
                model
                Cmd.none
                noError
                []
    in
    case msg of
        ClearAllItems ->
            BackendReturn
                { model | items = RemoteData.NotAsked }
                Cmd.none
                noError
                []

        FetchItem itemId ->
            let
                itemsUpdated =
                    Backend.Item.Utils.update itemId (always RemoteData.Loading) model.items

                itemIdAsString =
                    String.fromInt (fromEntityId itemId)

                cmd =
                    HttpBuilder.get ("https://hacker-news.firebaseio.com/v0/item/" ++ itemIdAsString ++ ".json")
                        |> withExpectJson decodeItem
                        |> HttpBuilder.send (RemoteData.fromResult >> HandleFetchItem itemId)
            in
            BackendReturn
                { model | items = itemsUpdated }
                cmd
                noError
                []

        FetchTopStories ->
            let
                itemsUpdated =
                    if RemoteData.isNotAsked model.items then
                        RemoteData.Loading

                    else
                        model.items

                cmd =
                    HttpBuilder.get "https://hacker-news.firebaseio.com/v0/topstories.json"
                        |> withExpectJson decodeItemIds
                        |> HttpBuilder.send (RemoteData.fromResult >> HandleFetchTopStories)
            in
            BackendReturn
                { model | items = itemsUpdated }
                cmd
                noError
                []

        HandleFetchItem itemId webData ->
            BackendReturn
                { model | items = Backend.Item.Utils.update itemId (always webData) model.items }
                Cmd.none
                -- Http call might have failed.
                (maybeHttpError webData "Backend.Item.Update" "HandleFetchItem")
                []

        HandleFetchTopStories webData ->
            let
                itemsUpdated =
                    if RemoteData.isLoading model.items then
                        RemoteData.Success Dict.empty

                    else
                        model.items

                itemsUpdatedWithItemIds =
                    case webData of
                        RemoteData.Success itemIds ->
                            let
                                -- Mark the items as NotAsked, so they will be fetched.
                                itemIdsNotAsked =
                                    List.map (\itemId -> ( itemId, RemoteData.NotAsked )) itemIds
                            in
                            Backend.Item.Utils.insertMultiple itemIdsNotAsked itemsUpdated

                        RemoteData.Failure error ->
                            RemoteData.Failure error

                        _ ->
                            -- Satisfy the compiler.
                            model.items

                trimItems =
                    -- For demo purposes, lets trim the dict to 20.
                    RemoteData.map
                        (\dict ->
                            dict
                                |> Dict.toList
                                |> List.take 20
                                |> Dict.fromList
                        )
                        itemsUpdatedWithItemIds
            in
            BackendReturn
                { model | items = trimItems }
                Cmd.none
                -- Http call might have failed.
                (maybeHttpError webData "Backend.Item.Update" "HandleFetchTopStories")
                []

        SetItemToNotAsked itemId ->
            let
                itemsUpdated =
                    Backend.Item.Utils.update itemId (always RemoteData.NotAsked) model.items
            in
            BackendReturn
                { model | items = itemsUpdated }
                Cmd.none
                noError
                []
