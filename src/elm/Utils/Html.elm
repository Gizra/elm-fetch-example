module Utils.Html exposing
    ( emptyNode
    , spinner
    )

import Html exposing (Attribute, Html, i, text)
import Html.Attributes exposing (class)


spinner : Html msg
spinner =
    i [ class "fa fa-spinner fa-spin" ] []


emptyNode : Html msg
emptyNode =
    text ""
