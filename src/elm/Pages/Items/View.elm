module Pages.Items.View exposing (view)

import Backend.Model exposing (ModelBackend)
import Html exposing (..)
import Pages.Items.Model exposing (Model, Msg(..))


view : ModelBackend -> Model -> Html Msg
view modelBackend model =
    div [] [ text "Items page" ]
