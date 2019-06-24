module Backend.Item.Utils exposing
    ( insertMultiple
    , update
    )

import AssocList as Dict exposing (Dict)
import Backend.Entities exposing (ItemId)
import Backend.Item.Model exposing (Item, ItemsDict, Msg(..))
import RemoteData exposing (WebData)


insertMultiple : List ( ItemId, WebData Item ) -> ItemsDict -> ItemsDict
insertMultiple newList dict =
    RemoteData.map
        (\innerDict ->
            let
                dictAsList =
                    Dict.toList innerDict
            in
            newList
                |> List.foldl
                    (\( itemId, webData ) accum ->
                        accum
                            |> List.append [ ( itemId, webData ) ]
                    )
                    dictAsList
                |> Dict.fromList
        )
        dict


update : ItemId -> (WebData Item -> WebData Item) -> ItemsDict -> ItemsDict
update itemId func dict =
    case RemoteData.toMaybe dict of
        Nothing ->
            dict

        Just innerDict ->
            case Dict.get itemId innerDict of
                Nothing ->
                    dict

                Just webData ->
                    RemoteData.map (\innerDict_ -> Dict.insert itemId (func webData) innerDict_) dict
