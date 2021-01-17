module Page.NotFound exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes


kids : List (Html msg)
kids =
    [ Html.text "" ]


attrs : List (Attribute msg)
attrs =
    [ Html.Attributes.classList [] ]
