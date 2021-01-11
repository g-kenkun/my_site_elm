module Post exposing (..)

import Iso8601
import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)
import Time



-- POST


type alias Post =
    { id : String
    , title : String
    , tags : List String
    , createdAt : Time.Posix
    , content : String
    }



-- DECODER


decoder : Decode.Decoder Post
decoder =
    Decode.succeed Post
        |> required "id" string
        |> required "title" string
        |> required "tags" (list string)
        |> required "createdAt" Iso8601.decoder
        |> required "content" string
