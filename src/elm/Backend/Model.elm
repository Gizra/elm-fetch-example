module Backend.Model exposing
    ( ModelBackend
    , Msg(..)
    , emptyModelBackend
    )

import Backend.Item.Model exposing (ItemsDict)
import RemoteData exposing (RemoteData)


{-| This model basically represents things we have locally which also belong
on the backend. So, conceptually it is a kind of a local cache of some of the
things on the backend.
-}
type alias ModelBackend =
    { items : ItemsDict
    }


emptyModelBackend : ModelBackend
emptyModelBackend =
    { items = RemoteData.NotAsked
    }


{-| These are all the messages related to getting things from the backend and
putting things back into the backend.
-}
type Msg
    = MsgItem Backend.Item.Model.Msg
