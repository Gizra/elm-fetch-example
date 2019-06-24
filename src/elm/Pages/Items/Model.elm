module Pages.Items.Model exposing (Model, Msg(..), emptyModel)

import Backend.Entities exposing (ItemId)


{-| In this example the page itself doesn't need to hold any data. Everything comes from the
modelBackend. However, it's easier to have an empty model, in preparation for data it may hold.
-}
type alias Model =
    {}


emptyModel : Model
emptyModel =
    {}


type Msg
    = ClearAllItems
    | SetItemToNotAsked ItemId
