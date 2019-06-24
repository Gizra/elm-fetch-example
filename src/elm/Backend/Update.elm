module Backend.Update exposing (updateBackend)

import Backend.Item.Update
import Backend.Model exposing (..)
import Backend.Types exposing (BackendReturn)
import Backend.Utils exposing (updateSubModel)
import Error.Utils exposing (noError)


updateBackend : Msg -> ModelBackend -> BackendReturn Msg
updateBackend msg model =
    let
        noChange =
            BackendReturn model Cmd.none noError []
    in
    case msg of
        MsgItem subMsg ->
            updateSubModel
                subMsg
                (\subMsg_ model_ -> Backend.Item.Update.update subMsg_ model_)
                (\subCmds -> MsgItem subCmds)
                model
