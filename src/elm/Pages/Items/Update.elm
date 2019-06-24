module Pages.Items.Update exposing (update)

import App.Model exposing (PagesReturn)
import Backend.Item.Model
import Backend.Model exposing (ModelBackend)
import Error.Utils exposing (noError)
import Pages.Items.Model exposing (Model, Msg(..))


update : ModelBackend -> Msg -> Model -> PagesReturn Model Msg
update modelBackend msg model =
    let
        noChange =
            PagesReturn
                model
                Cmd.none
                noError
                []
    in
    case msg of
        ClearAllItems ->
            PagesReturn
                model
                Cmd.none
                noError
                -- Clear all items.
                [ Backend.Item.Model.ClearAllItems
                    |> Backend.Model.MsgItem
                    |> App.Model.MsgBackend
                ]

        SetItemToNotAsked itemId ->
            PagesReturn
                model
                Cmd.none
                noError
                -- Ask the backend to change the Item to NotAsked.
                [ Backend.Item.Model.SetItemToNotAsked itemId
                    |> Backend.Model.MsgItem
                    |> App.Model.MsgBackend
                ]
