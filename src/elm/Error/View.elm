module Error.View exposing (view, viewError)

import Error.Model exposing (Error, ErrorType(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Utils.Html exposing (emptyNode)
import Utils.WebData


view : List Error -> Html msg
view errors =
    if List.isEmpty errors then
        emptyNode

    else
        div [ class "debug-errors" ]
            [ ul [] (List.map viewError errors)
            ]


viewError : Error -> Html msg
viewError error =
    let
        apply str =
            li []
                [ text <| error.module_ ++ "." ++ error.location ++ ": "
                , str
                ]
    in
    case error.error of
        Decoder err ->
            Json.Decode.errorToString err
                |> text
                |> apply

        Http err ->
            Utils.WebData.viewError err
                |> apply

        Plain txt ->
            text txt
                |> apply
