module Main exposing (applyFetch, main, updateAndThenFetchWhatTheViewNeeds)

import App.Fetch
import App.Model exposing (Flags, Model, Msg)
import App.Update
import App.View
import Browser
import Update.Extra exposing (sequence)



--main : Program Flags Model Msg


main =
    Browser.element
        { init = App.Update.init
        , update = updateAndThenFetchWhatTheViewNeeds
        , view = App.View.view
        , subscriptions = App.Update.subscriptions
        }


{-| This integrates the `fetch` function descibed in `Pages.OpenSessions.View`
and `App.View` into the Elm architecture. The idea Error.Utilsis to manage data from the
backend central (for the sake of a single source of truth), and yet allow the
view hierarchy to tell us which data needs to be loaded (since that depends on
the way the `view` function is dispatched, not the `update` function).
-}
updateAndThenFetchWhatTheViewNeeds : Msg -> Model -> ( Model, Cmd Msg )
updateAndThenFetchWhatTheViewNeeds msg model =
    App.Update.update msg model
        |> applyFetch App.Fetch.fetch App.Update.update


applyFetch : (model -> List msg) -> (msg -> model -> ( model, Cmd msg )) -> ( model, Cmd msg ) -> ( model, Cmd msg )
applyFetch fetch update resultSoFar =
    -- Note that we call ourselves recursively. So, it's vitally important that
    -- the `fetch` implementations use a `WebData`-like strategy to indicate
    -- that a request is in progress, and doesn't need to be triggered again.
    -- Otherwise, we'll immediately be in an infinite loop.
    --
    -- We initially sequence through the app's `update`, and only recurse once
    -- all the messages have been processed.
    let
        msgs =
            fetch (Tuple.first resultSoFar)
    in
    if List.isEmpty msgs then
        resultSoFar

    else
        sequence update msgs resultSoFar
            |> applyFetch fetch update
