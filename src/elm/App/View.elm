module App.View exposing (view)

import App.Model exposing (Model, Msg(..))
import App.Types exposing (Page(..))
import Error.View
import Html exposing (..)
import Pages.Items.View


view : Model -> Html Msg
view model =
    let
        errorElement =
            Error.View.view model.errors
    in
    case model.activePage of
        Items ->
            div []
                [ errorElement
                , Html.map MsgPageItems <|
                    Pages.Items.View.view
                        model.backend
                        model.pageItems
                ]
