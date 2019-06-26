module App.Fetch exposing (fetch)

import App.Model exposing (..)
import App.Types exposing (Page(..))
import Pages.Items.Fetch


{-| Call the needed `fetch` function, based on the active page.
-}
fetch : Model -> List Msg
fetch model =
    case model.activePage of
        Items ->
            Pages.Items.Fetch.fetch model.backend
                |> List.map (\subMsg -> MsgBackend subMsg)
