module Main exposing (..)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Page
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Post as Post
import Url
import Url.Parser as Parser exposing ((</>), Parser, custom, oneOf, s, string, top)


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | Home Home.Model
    | Post Post.Model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            Page.view never
                { title = "Not Found"
                , attrs = NotFound.attrs
                , kids = NotFound.kids
                }

        Home home ->
            Page.view HomeMsg (Home.view home)

        Post post ->
            Page.view PostMsg (Post.view post)



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    stepUrl url
        { key = key
        , page = NotFound
        }



-- UPDATE


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | PostMsg Post.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        UrlChanged url ->
            stepUrl url model

        HomeMsg msg ->
            case model.page of
                Home home ->
                    stepHome model (Home.update msg home)

                _ ->
                    ( model, Cmd.none )

        PostMsg msg ->
            case model.page of
                Post post ->
                    stepPost model (Post.update msg post)

                _ ->
                    ( model, Cmd.none )


stepHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome model ( home, cmds ) =
    ( { model | page = Home home }
    , Cmd.map HomeMsg cmds
    )


stepPost : Model -> ( Post.Model, Cmd Post.Msg ) -> ( Model, Cmd Msg )
stepPost model ( post, cmds ) =
    ( { model | page = Post post }
    , Cmd.map PostMsg cmds
    )



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ route top
                    (stepHome model Home.init)
                , route (s "posts" </> postId_)
                    (\postId ->
                        stepPost model (Post.init postId)
                    )
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser


postId_ : Parser (String -> a) a
postId_ =
    custom "POST_ID" Just
