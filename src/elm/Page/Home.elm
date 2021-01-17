module Page.Home exposing (..)

-- MODEL

import Api
import Html exposing (Html, a, article, div, h2, text)
import Html.Attributes exposing (class, href)
import Html.Lazy exposing (lazy)
import Http
import Json.Decode as Decode
import Page
import Post
import Url.Builder as Builder


type alias Model =
    { posts : Posts }


type Posts
    = Failure
    | Loading
    | Success (List Post.Post)


init : ( Model, Cmd Msg )
init =
    ( Model Loading
    , getLatestPost
    )



-- UPDATE


type Msg
    = GotPosts (Result Http.Error (List Post.Post))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotPosts result ->
            case result of
                Ok posts ->
                    ( { model
                        | posts = Success posts
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | posts = Failure }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Page.Details Msg
view model =
    { title = "IO.inspect(独り言)"
    , attrs = []
    , kids = [ lazy viewHome model.posts ]
    }



-- VIEW HOME


viewHome : Posts -> Html Msg
viewHome posts =
    div [ class "grid grid-cols-3" ]
        [ viewPosts posts
        ]


viewPosts : Posts -> Html Msg
viewPosts posts =
    div [ class "col-span-2" ]
        [ case posts of
            Failure ->
                text ""

            Loading ->
                text ""

            Success fetchedPosts ->
                div [ class "divide-y" ] (List.map viewPost fetchedPosts)
        ]


viewPost : Post.Post -> Html msg
viewPost post =
    article []
        [ h2 []
            [ a [ href (Builder.absolute [ "posts", post.id ] []) ] [ text post.title ] ]
        ]



-- HTTP


getLatestPost : Cmd Msg
getLatestPost =
    getRequest (buildUrl [ "blog", "posts" ] []) <| Http.expectJson GotPosts (Decode.list Post.decoder)


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
    Builder.crossOrigin "http://localhost:4000"
        ("api" :: paths)
        queryParams
