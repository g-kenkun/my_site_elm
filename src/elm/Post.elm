module Post exposing (..)

import Html exposing (Attribute, Html)
import Iso8601
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Markdown
import Time



-- POST


type alias Post =
    { id : String
    , title : String
    , tags : List String
    , created_at : Time.Posix
    , content : String
    }


type alias Count =
    { count : Int }



-- CONVERSIONS


contentToHtml : Post -> List (Attribute msg) -> Html msg
contentToHtml post attributes =
    Markdown.toHtml attributes post.content



-- DECODER


postDecoder : Decode.Decoder Post
postDecoder =
    Decode.succeed Post
        |> required "id" string
        |> required "title" string
        |> required "tags" (list string)
        |> required "created_at" Iso8601.decoder
        |> required "content" string


countDecoder : Decode.Decoder Count
countDecoder =
    Decode.succeed Count
        |> required "count" int
