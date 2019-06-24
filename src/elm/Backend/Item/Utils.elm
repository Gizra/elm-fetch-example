module Backend.Item.Utils exposing
    ( insertItemIds
    , update
    )

import AssocList as Dict exposing (Dict)
import Backend.Entities exposing (ItemId)
import Backend.Item.Model exposing (Item, ItemsDict, Msg(..))
import RemoteData exposing (WebData)
import StorageKey exposing (StorageKey)


{-| Insert item IDs (e.g. for top stories), where the Item itself is still `NotAsked`. That is,
we haven't fetched the Item itself yet.
-}
insertItemIds : List ItemId -> ItemsDict -> ItemsDict
insertItemIds newList dict =
    RemoteData.map
        (\innerDict ->
            let
                dictAsList =
                    Dict.toList innerDict
            in
            newList
                |> List.foldl
                    (\itemId accum ->
                        accum
                            -- We still don't have the Item, so we mark it as `NotAsked`.
                            |> List.append [ ( StorageKey.Existing itemId, RemoteData.NotAsked ) ]
                    )
                    dictAsList
                |> Dict.fromList
        )
        dict


update : StorageKey ItemId -> (WebData Item -> WebData Item) -> ItemsDict -> ItemsDict
update storageKey func dict =
    case RemoteData.toMaybe dict of
        Nothing ->
            dict

        Just innerDict ->
            case Dict.get storageKey innerDict of
                Nothing ->
                    dict

                Just webData ->
                    RemoteData.map (\innerDict_ -> Dict.insert storageKey (func webData) innerDict_) dict
