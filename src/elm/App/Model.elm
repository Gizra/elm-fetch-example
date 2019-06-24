module App.Model exposing
    ( Flags
    , Model
    , Msg(..)
    , PagesReturn
    , emptyModel
    )

import App.Types exposing (Page(..))
import Backend.Model
import Error.Model exposing (Error)
import Pages.Items.Model
import Time


type alias PagesReturn subModel subMsg =
    { model : subModel
    , cmd : Cmd subMsg
    , error : Maybe Error
    , appMsgs : List Msg
    }


type Msg
    = MsgBackend Backend.Model.Msg
    | MsgPageItems Pages.Items.Model.Msg
    | NoOp
    | SetActivePage Page
    | SetDomElementFocus String


{-| Placeholder for flags.
-}
type alias Flags =
    {}


type alias Model =
    { backend : Backend.Model.ModelBackend
    , errors : List Error
    , activePage : Page
    , currentDate : Time.Posix
    , pageItems : Pages.Items.Model.Model
    }


emptyModel : Model
emptyModel =
    { backend = Backend.Model.emptyModelBackend
    , errors = []
    , activePage = App.Types.Items
    , currentDate = Time.millisToPosix 0
    , pageItems = Pages.Items.Model.emptyModel
    }
