module Utils.WebData exposing
    ( errorString
    , viewError
    , whenNotAsked
    )

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import HttpBuilder exposing (..)
import Json.Decode exposing (Decoder, decodeString)
import RemoteData exposing (..)


{-| Get Error message as `String`.
-}
errorString : Http.Error -> String
errorString error =
    case error of
        Http.BadUrl message ->
            "URL is not valid:" ++ message

        Http.BadPayload message _ ->
            "The server responded with data of an unexpected type: " ++ message

        Http.NetworkError ->
            "There was a network error."

        Http.Timeout ->
            "The network request timed out."

        Http.BadStatus response ->
            case decodeString decodeTitle response.body of
                Ok err ->
                    err

                Err _ ->
                    response.status.message


decodeTitle : Decoder String
decodeTitle =
    Json.Decode.field "title" Json.Decode.string


{-| Provide some `Html` to view an error message.
-}
viewError : Http.Error -> Html any
viewError error =
    div [] [ text <| errorString error ]


{-| Return `Just msg` if we're `NotAsked`, otherwise `Nothing`. Sort of the
opposite of `map`. We use this in order to kick off some process if we're
`NotAsked`, but not otherwise.
-}
whenNotAsked : msg -> RemoteData e a -> Maybe msg
whenNotAsked msg data =
    case data of
        NotAsked ->
            Just msg

        _ ->
            Nothing
