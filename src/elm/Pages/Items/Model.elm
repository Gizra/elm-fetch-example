module Pages.Items.Model exposing (Model, Msg(..), emptyModel)

import Backend.Entities exposing (ItemId)
import StorageKey exposing (StorageKey)


type alias Model =
    {}


emptyModel : Model
emptyModel =
    {}


type Msg
    = ClearAllItems
    | SetItemToNotAsked ItemId
