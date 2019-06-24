module Utils.WebData exposing
    ( errorString
    , getError
    , sendWithHandler
    , unwrap
    , viewError
    , whenNotAsked
    , whenSuccess
    )

import Html exposing (..)
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


whenSuccess : RemoteData e a -> result -> (a -> result) -> result
whenSuccess remoteData default func =
    case remoteData of
        Success val ->
            func val

        _ ->
            default


sendWithHandler : Decoder a -> (Result Http.Error a -> msg) -> RequestBuilder a1 -> Cmd msg
sendWithHandler decoder tagger builder =
    builder
        |> withExpect (Http.expectJson decoder)
        |> send tagger


getError : RemoteData e a -> Maybe e
getError remoteData =
    case remoteData of
        Failure err ->
            Just err

        _ ->
            Nothing


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


{-| Ported from RemoteData 5.0.0 (Elm 0.19).
Take a default value, a function and a `RemoteData`.
Return the default value if the `RemoteData` is something other than `Success a`.
If the `RemoteData` is `Success a`, apply the function on `a` and return the `b`.
-}
unwrap : b -> (a -> b) -> RemoteData e a -> b
unwrap default function remoteData =
    case remoteData of
        Success data ->
            function data

        _ ->
            default
