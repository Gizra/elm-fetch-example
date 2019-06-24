module Utils.EditableWebData exposing
    ( getValue
    , viewMaybeError
    )

import Editable
import Editable.WebData exposing (EditableWebData, EditableWebDataWrapper)
import Html exposing (..)
import Html.Attributes exposing (class)
import RemoteData exposing (..)
import Utils.Html exposing (emptyNode)
import Utils.WebData exposing (viewError)


getValue : EditableWebDataWrapper a b -> a
getValue editable =
    editable
        |> Editable.WebData.toEditable
        |> Editable.value


{-| Provide some `Html` to view an error message for an `EditableWebData`.
-}
viewMaybeError : EditableWebDataWrapper a b -> Html msg
viewMaybeError editable =
    case Editable.WebData.toWebData editable of
        Failure error ->
            div [ class "alert alert-danger" ]
                [ viewError error
                ]

        _ ->
            emptyNode
