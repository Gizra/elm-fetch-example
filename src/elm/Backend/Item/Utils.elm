module Backend.Item.Utils exposing
    ( insertMultiple
    , update
    )

import AssocList as Dict exposing (Dict)
import Backend.Entities exposing (ItemId)
import Backend.Item.Model exposing (Item, ItemsDict, Msg(..))
import Editable.WebData exposing (EditableWebData)
import RemoteData
import StorageKey exposing (StorageKey)


insertMultiple : List ( ItemId, Item ) -> ItemsDict -> ItemsDict
insertMultiple newList dict =
    RemoteData.map
        (\innerDict ->
            let
                dictAsList =
                    Dict.toList innerDict
            in
            newList
                |> List.foldl
                    (\( itemId, doc ) accum ->
                        accum
                            |> List.append [ ( StorageKey.Existing itemId, Editable.WebData.create doc ) ]
                    )
                    dictAsList
                |> Dict.fromList
        )
        dict


update : StorageKey ItemId -> (EditableWebData Item -> EditableWebData Item) -> ItemsDict -> ItemsDict
update storageKey func dict =
    case RemoteData.toMaybe dict of
        Nothing ->
            dict

        Just innerDict ->
            case Dict.get storageKey innerDict of
                Nothing ->
                    dict

                Just editable ->
                    RemoteData.map (\innerDict_ -> Dict.insert storageKey (func editable) innerDict_) dict
