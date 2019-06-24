module Pages.Items.Model exposing (Model, Msg(..), emptyModel)

import Backend.Entities exposing (ItemId)
import StorageKey exposing (StorageKey)


type alias Model =
    { selectedItem : Maybe (StorageKey ItemId)
    }


emptyModel : Model
emptyModel =
    { selectedItem = Nothing
    }


type Msg
    = SetSelectedItem (Maybe (StorageKey ItemId))
