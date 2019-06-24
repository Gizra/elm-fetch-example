module Pages.Items.Fetch exposing (fetch)

import AssocList as Dict
import Backend.Item.Model
import Backend.Model
import RemoteData
import Utils.WebData exposing (whenNotAsked)


fetch : Backend.Model.ModelBackend -> List Backend.Model.Msg
fetch modelBackend =
    let
        topStories =
            [ whenNotAsked
                (Backend.Item.Model.FetchTopStories
                    |> Backend.Model.MsgItem
                )
                modelBackend.items
            ]

        itemsToFetch =
            -- If we already fetched the top stories, lets fetch the Items 3 at a time (i.e. 3 requests at
            -- the same time).
            case RemoteData.toMaybe modelBackend.items of
                Just dict ->
                    let
                        dictAsList =
                            Dict.toList dict
                    in
                    if List.any (\( _, webData ) -> RemoteData.isLoading webData) dictAsList then
                        -- We are still loading, so wait for that batch to end.
                        []

                    else
                        -- Find the first/ next 3 items marked as NotAsked.
                        dictAsList
                            |> List.foldl
                                (\( itemId, webData ) accum ->
                                    if List.length accum >= 3 then
                                        -- We found all three items that need to be loaded.
                                        accum

                                    else if RemoteData.isNotAsked webData then
                                        Just
                                            (Backend.Item.Model.FetchItem itemId
                                                |> Backend.Model.MsgItem
                                            )
                                            :: accum

                                    else
                                        accum
                                )
                                []

                Nothing ->
                    []

        _ =
            Debug.log "itemsToFetch" itemsToFetch
    in
    topStories
        |> List.append itemsToFetch
        |> List.filterMap identity
