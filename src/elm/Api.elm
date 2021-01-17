module Api exposing (..)

import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode as Decode
import Post
import Url
import Url.Builder as Builder


type Msg
    = GotPostPreviews (Result Http.Error Post.Post)


buildUrl : List String -> List Builder.QueryParameter -> String
buildUrl paths queryParams =
    Builder.crossOrigin "http://localhost:4000"
        ("api" :: paths)
        queryParams



-- HTTP


getLatestPost : Cmd Msg
getLatestPost =
    getRequest (buildUrl [] []) <| Http.expectJson GotPostPreviews Post.decoder


getRequest : String -> Http.Expect Msg -> Cmd Msg
getRequest url expect =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = expect
        , timeout = Nothing
        , tracker = Nothing
        }
