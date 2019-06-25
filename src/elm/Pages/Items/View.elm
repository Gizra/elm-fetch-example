module Pages.Items.View exposing (view)

import AssocList as Dict
import Backend.Entities exposing (ItemId, fromEntityId)
import Backend.Item.Model exposing (Item)
import Backend.Model exposing (ModelBackend)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Pages.Items.Model exposing (Model, Msg(..))
import RemoteData exposing (WebData)
import Utils.WebData


view : ModelBackend -> Model -> Html Msg
view modelBackend model =
    div []
        [ viewItems modelBackend model
        ]


viewItems : ModelBackend -> Model -> Html Msg
viewItems modelBackend model =
    case modelBackend.items of
        RemoteData.Success dict ->
            if Dict.isEmpty dict then
                div [] [ text "Weird, but there are no top stories." ]

            else
                div []
                    [ button [ onClick ClearAllItems ] [ text "Clear all" ]
                    , ul [] (List.map (viewItem model) (Dict.toList dict))
                    ]

        RemoteData.Failure error ->
            div [ class "error" ]
                [ text "Could not load the top stories due to error."
                , Utils.WebData.viewError error
                ]

        _ ->
            div []
                [ text "Loading top stories..."
                ]


viewItem : Model -> ( ItemId, WebData Item ) -> Html Msg
viewItem model ( itemId, webData ) =
    let
        itemIdAsString =
            String.fromInt (fromEntityId itemId)

        itemHtml =
            case webData of
                RemoteData.Success item ->
                    div []
                        [ text item.title
                        , text " "
                        , button [ onClick <| SetItemToNotAsked itemId ] [ text "X" ]
                        ]

                RemoteData.Failure error ->
                    div [ class "error" ] [ Utils.WebData.viewError error ]

                RemoteData.Loading ->
                    div [] [ text "Loading..." ]

                RemoteData.NotAsked ->
                    div [] [ text "Not asked yet..." ]
    in
    li []
        [ div [] [ text <| "Item ID " ++ itemIdAsString ]
        , itemHtml
        ]
