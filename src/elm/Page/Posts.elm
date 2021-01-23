module Page.Posts exposing (..)

import Html exposing (Html)
import Http
import Json.Decode as Decode
import Page
import Post
import Url.Builder as Builder


type alias Model =
    { posts : Posts
    , count : Count
    }


type Posts
    = PostsFailure
    | PostsLoading
    | PostsSuccess (List Post.Post)


type Count
    = CountFailure
    | CountLoading
    | CountSuccess Post.Count


init : ( Model, Cmd Msg )
init =
    ( Model PostsLoading CountLoading
    , Cmd.batch [ getPosts, getPostCount ]
    )



-- UPDATE


type Msg
    = GotPosts (Result Http.Error (List Post.Post))
    | GotCount (Result Http.Error Post.Count)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotPosts result ->
            case result of
                Ok posts ->
                    ( { model
                        | posts = PostsSuccess posts
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | posts = PostsFailure
                      }
                    , Cmd.none
                    )

        GotCount result ->
            case result of
                Ok count ->
                    ( { model
                        | count = CountSuccess count
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | count = CountFailure
                      }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Page.Details Msg
view model =
    { title = "IO.inspect(独り言)"
    , attrs = []
    , kids = []
    }



---- VIEW PAGINATION
--
--
--viewPagination : Count -> Html Msg
--viewPagination count =
-- HTTP


getPostCount : Cmd Msg
getPostCount =
    getRequest (buildUrl [ "blog", "posts", "count" ] []) <| Http.expectJson GotCount Post.countDecoder


getPosts : Cmd Msg
getPosts =
    getRequest (buildUrl [ "blog", "posts" ] [ Builder.int "limit" 10 ]) <| Http.expectJson GotPosts (Decode.list Post.postDecoder)


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


buildUrl : List String -> List Builder.QueryParameter -> String
buildUrl paths queryParams =
    Builder.crossOrigin "https://api.g-kenkun.dev"
        paths
        queryParams
