module Pages.Items.Fetch exposing (fetch)

import Backend.Item.Model
import Backend.Model
import Utils.WebData exposing (whenNotAsked)


fetch : Backend.Model.ModelBackend -> List Backend.Model.Msg
fetch modelBackend =
    let
        itemsData =
            [ whenNotAsked
                (Backend.Item.Model.FetchTopStories
                    |> Backend.Model.MsgItem
                )
                modelBackend.items
            ]
    in
    itemsData
        |> List.filterMap identity
