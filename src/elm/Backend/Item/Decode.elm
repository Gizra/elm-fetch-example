module Backend.Item.Decode exposing (decodeItem, decodeItemIds)

import Backend.Entities exposing (ItemId, decodeEntityId)
import Backend.Item.Model exposing (Item)
import Json.Decode exposing (Decoder, list, string, succeed)
import Json.Decode.Pipeline exposing (required)


decodeItem : Decoder Item
decodeItem =
    succeed Item
        |> required "title" string


decodeItemIds : Decoder (List ItemId)
decodeItemIds =
    list decodeEntityId
