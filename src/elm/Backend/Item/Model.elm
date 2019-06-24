module Backend.Item.Model exposing
    ( Item
    , ItemsDict
    , Msg(..)
    , emptyItem
    )

import AssocList as Dict exposing (Dict)
import Backend.Entities exposing (ItemId)
import Editable.WebData exposing (EditableWebData)
import RemoteData exposing (RemoteData, WebData)
import StorageKey exposing (StorageKey)


type alias ItemsDict =
    WebData (Dict (StorageKey ItemId) (EditableWebData Item))


{-| Item is a single story item.
-}
type alias Item =
    { title : String
    }


emptyItem : Item
emptyItem =
    { title = ""
    }


type Msg
    = FetchTopStories
    | HandleFetchTopStories (WebData (List ItemId))
