module App.Update exposing
    ( init
    , subscriptions
    , update
    )

import App.Fetch exposing (fetch)
import App.Model exposing (..)
import App.Types exposing (Page(..))
import App.Utils exposing (updateSubModel)
import Backend.Update
import Browser.Dom as Dom
import Pages.Items.Update
import Task


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        modelUpdated =
            -- We could set the Flags here.
            emptyModel

        -- Let the Fetcher act upon the initial active page.
        cmds =
            fetch emptyModel
                |> List.map
                    (\msg ->
                        Task.succeed msg
                            |> Task.perform identity
                    )
                |> Cmd.batch
    in
    ( modelUpdated
    , cmds
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noChange =
            ( model, Cmd.none )
    in
    case msg of
        SetActivePage page ->
            ( { model | activePage = page }
            , Cmd.none
            )

        MsgBackend subMsg ->
            updateSubModel
                subMsg
                model.backend
                (\subMsg_ subModel -> Backend.Update.updateBackend subMsg_ subModel)
                (\subModel model_ -> { model_ | backend = subModel })
                (\subCmds -> MsgBackend subCmds)
                model

        MsgPageItems subMsg ->
            updateSubModel
                subMsg
                model.pageItems
                (\subMsg_ subModel -> Pages.Items.Update.update model.backend subMsg_ subModel)
                (\subModel model_ -> { model_ | pageItems = subModel })
                (\subCmds -> MsgPageItems subCmds)
                model

        NoOp ->
            ( model, Cmd.none )

        SetDomElementFocus elementId ->
            ( model
            , Task.attempt (\_ -> NoOp) (Dom.focus elementId)
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
