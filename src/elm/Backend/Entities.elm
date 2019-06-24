module Backend.Entities exposing
    ( EntityId
    , EntityUuid
    , ItemId
    , decodeEntityId
    , decodeEntityUuid
    , encodeEntityId
    , encodeEntityUuid
    , fromEntityId
    , fromEntityUuid
    , toEntityId
    , toEntityUuid
    )

{-|


## Why are all the ID types here?

It's nice to have type-safe IDs for backend entities, but it tends
to lead to circular imports if you put the ID types in the "usual"
place alongside the data-type itself.

So, it seems simpler to just have one ID type here for each of our backend
entities.

The way this is implemented is inspired by
[johneshf/elm-tagged](http://package.elm-lang.org/packages/joneshf/elm-tagged/latest).

What we do instead is have a an `EntityId` type, which takes what we call a "phantom"
type variable -- a type variable that isn't actually used for any data.
This gives us all the type-safety we need at compile time, but lets us have a single
way of actually getting the `Int` or `String` when we need it.

-}

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)



{-
   The rest of this are the phantom types for each entity we're using.
   This would benefit from some kind of code-generation step, since you
   could generate the code below easily from a list of base types.

   We create the type aliases so that we can just say

       ItemId

   most of the time, rather than the more verbose

       EntityId ItemId

-}


type alias ItemId =
    EntityId ItemType


type ItemType
    = ItemType



------- Helper functions


{-| This is a wrapper for an `Int` id. It takes a "phantom" type variable
in order to gain type-safety about what kind of entity it is an ID for.
So, to specify that you have an id for a clinic, you would say:

    type ClinicId
        = ClinicId

    clinidId : EntityId ClinicId

-}
type EntityId a
    = EntityId Int


{-| This is how you create an `EntityId`, if you have an `Int`. You can create
any kind of `EntityId` this way ... so you would normally only do this in
situations that are fundamentally untyped, such as when you are decoding
JSON data. Except in those kind of "boundary" situations, you should be
working with the typed `EntityIds`.
-}
toEntityId : Int -> EntityId a
toEntityId =
    EntityId


{-| This is how you get an `Int` back from a `EntityId`. You should only use
this in boundary situations, where you need to send the id out in an untyped
way. Normally, you should just pass around the `EntityId` itself, to retain
type-safety.
-}
fromEntityId : EntityId a -> Int
fromEntityId (EntityId a) =
    a


{-| Decodes a EntityId.

This just turns JSON int (or string that is an int) to an `EntityId`. You need
to supply the `field "id"` yourself, if necessary, since id's could be present
in other fields as well.

This decodes any kind of `EntityId` you like (since there is fundamentally no type
information in the JSON iself, of course). So, you need to verify that the type
is correct yourself.

-}
decodeEntityId : Decoder (EntityId a)
decodeEntityId =
    Json.Decode.map toEntityId Json.Decode.int


{-| Encodes any kind of `EntityId` as a JSON int.
-}
encodeEntityId : EntityId a -> Value
encodeEntityId =
    Json.Encode.int << fromEntityId


{-| This is a wrapper for an UUID.
-}
type EntityUuid a
    = EntityUuid String


{-| This is how you create a `EntityUuid`, if you have a `String`. You can create
any kind of `EntityUuid` this way ... so you would normally only do this in
situations that are fundamentally untyped, such as when you are decoding
JSON data. Except in those kind of "boundary" situations, you should be
working with the typed `EntityUuid`s.
-}
toEntityUuid : String -> EntityUuid a
toEntityUuid =
    EntityUuid


{-| This is how you get a `String` back from an `EntityUuid`. You should only use
this in boundary situations, where you need to send the UUID out in an untyped
way. Normally, you should just pass around the `EntityUuid` itself, to retain
type-safety.
-}
fromEntityUuid : EntityUuid a -> String
fromEntityUuid (EntityUuid a) =
    a


{-| Decodes an `EntityUuid`.
-}
decodeEntityUuid : Decoder (EntityUuid a)
decodeEntityUuid =
    Json.Decode.map toEntityUuid Json.Decode.string


{-| Encodes any kind of `EntityUuid` as a JSON string.
-}
encodeEntityUuid : EntityUuid a -> Value
encodeEntityUuid =
    Json.Encode.string << fromEntityUuid
