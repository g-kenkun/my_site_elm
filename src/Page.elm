module Page exposing (..)

import Browser exposing (Document)
import Html exposing (Attribute, Html, a, div, footer, header, nav, span, text)
import Html.Attributes exposing (class, href)


type alias Details msg =
    { title : String
    , attrs : List (Attribute msg)
    , kids : List (Html msg)
    }



-- MODEL


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
    { title = details.title
    , body =
        [ viewHeader
        , Html.map toMsg <| div details.attrs details.kids
        , viewFooter
        ]
    }



-- VIEW


viewHeader : Html msg
viewHeader =
    header [ class "frex justify-between" ]
        [ span []
            [ text "IO.inspect(独り言)" ]
        , nav
            []
            [ a [ href "/" ] [ text "Home" ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [] []
