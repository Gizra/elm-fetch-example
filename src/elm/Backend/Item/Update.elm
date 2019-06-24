module Backend.Item.Update exposing (update)

import Backend.Item.Decode exposing (decodeItemIds)
import Backend.Item.Model exposing (Msg(..))
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

        HandleFetchTopStories webData ->
            let
                itemsUpdated =
                    -- @todo
                    model.items
            in
            BackendReturn
                { model | items = itemsUpdated }
                Cmd.none
                -- Http call might have failed.
                (maybeHttpError webData "Backend.Item.Update" "HandleFetch")
                []
