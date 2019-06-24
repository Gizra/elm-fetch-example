module Backend.Item.Model exposing
    ( Item
    , ItemsDict
    , Msg(..)
    )

import AssocList as Dict exposing (Dict)
import Backend.Entities exposing (ItemId)
import RemoteData exposing (RemoteData, WebData)


type alias ItemsDict =
    WebData (Dict ItemId (WebData Item))


{-| Item is a single story item.
-}
type alias Item =
    { title : String
    }


type Msg
    = ClearAllItems
    | FetchItem ItemId
    | FetchTopStories
    | HandleFetchItem ItemId (WebData Item)
    | HandleFetchTopStories (WebData (List ItemId))
    | SetItemToNotAsked ItemId
