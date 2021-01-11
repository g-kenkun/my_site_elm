module Page.Home exposing (..)

-- MODEL

import Html exposing (Html)
import Html.Lazy exposing (lazy)
import Http
import Page
import Post


type alias Model =
    { posts : Posts }


type Posts
    = Failure
    | Loading
    | Success (List Post.Post)


init : ( Model, Cmd Msg )
init =
    ( Model Loading
    , Cmd.none
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
    Html.text ""
