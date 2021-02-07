module Page.Post exposing (..)

import Html exposing (Html, article, div, text)
import Html.Attributes exposing (class)
import Html.Lazy exposing (lazy)
import Http
import Page
import Post
import Url.Builder as Builder


type alias Model =
    { post : Post }


type Post
    = Failure
    | Loading
    | Success Post.Post


init : String -> ( Model, Cmd Msg )
init postId =
    ( Model Loading
    , getPost postId
    )



-- UPDATE


type Msg
    = GotPost (Result Http.Error Post.Post)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotPost result ->
            case result of
                Ok post ->
                    ( { model
                        | post = Success post
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | post = Failure }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Page.Details Msg
view model =
    { title = "IO.inspect(独り言)"
    , attrs = []
    , kids = [ lazy viewPost model.post ]
    }



-- VIEW POST


viewPost : Post -> Html Msg
viewPost post =
    div [ class "grid grid-cols-3" ]
        [ case post of
            Failure ->
                text ""

            Loading ->
                text ""

            Success fetchedPost ->
                article [ class "col-span-2 prose" ]
                    [ Post.contentToHtml fetchedPost []
                    ]
        ]



-- HTTP


getPost : String -> Cmd Msg
getPost postId =
    getRequest (buildUrl [ "blog", "posts", postId ] []) <| Http.expectJson GotPost Post.postDecoder


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
