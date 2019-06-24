module Pages.Items.Update exposing (update)

import App.Model exposing (PagesReturn)
import Backend.Model exposing (ModelBackend)
import Error.Utils exposing (noError)
import Pages.Items.Model exposing (Model, Msg(..))


update : ModelBackend -> Msg -> Model -> PagesReturn Model Msg
update modelBackend msg model =
    let
        noChange =
            PagesReturn
                model
                Cmd.none
                noError
                []
    in
    case msg of
        SetSelectedItem maybeStorageKey ->
            PagesReturn
                { model | selectedItem = maybeStorageKey }
                Cmd.none
                noError
                []
