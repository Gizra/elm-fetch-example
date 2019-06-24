module App.View exposing (view)

import App.Model exposing (Model, Msg(..))
import App.Types exposing (Page(..))
import Browser
import Error.View
import Html exposing (..)
import Pages.Items.View
import Utils.Html exposing (emptyNode)


view : Model -> Html Msg
view model =
    let
        errorElement =
            Error.View.view model.errors

        -- For demo purposes only, as we use elm-reactor. CSS should be added using a SASS file.
        styleHtml =
            Html.node "style"
                []
                [ Html.text
                    """
                    @import url('http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css');

                    """
                ]
    in
    case model.activePage of
        Items ->
            div []
                [ styleHtml
                , errorElement
                , Html.map MsgPageItems <|
                    Pages.Items.View.view
                        model.backend
                        model.pageItems
                ]
