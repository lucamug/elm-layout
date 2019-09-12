module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes


type alias Model =
    { x : Int
    , y : Int
    , emptyPage : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { x = flags.x
      , y = flags.y
      , emptyPage = flags.emptyPage
      }
    , Cmd.none
    )


type Msg
    = DoNothing
    | OnResize Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        OnResize x y ->
            ( { model | x = x, y = y }, Cmd.none )


isMobile : Model -> Bool
isMobile model =
    model.x < 600


view : Model -> Html.Html Msg
view model =
    let
        content =
            if isMobile model then
                innerContent

            else
                el
                    [ width <| px 300
                    , height <| px 300
                    , Border.width 10
                    , Border.rounded 20
                    , centerX
                    , centerY
                    , Background.color <| rgba 1 1 0.8 0.7
                    ]
                <|
                    innerContent

        innerContent =
            column
                [ scrollbarY
                , paddingXY 20 20
                , spacing 20
                , Border.width 10
                , Border.color <| rgb 1 0 0 -- Border red
                , Background.color <| rgba 1 1 0.8 0.9 -- Yellow background
                ]
                ((if model.emptyPage then
                    [ el [ Font.size 30 ] <| text "Empty Page"
                    , link [] { label = text "Go to NOT Empty Page", url = "index.html" }
                    ]

                  else
                    [ el [ Font.size 30 ] <| text "NOT Empty Page"
                    , link [] { label = text "Go to Empty Page", url = "index-empty.html" }
                    ]
                 )
                    ++ [ paragraph [] [ text <| "x = " ++ String.fromInt model.x ++ ", y = " ++ String.fromInt model.y ]
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field A", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field B", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field C", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field D", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field E", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                       , Input.text [] { label = Input.labelAbove [] <| text "Field F", onChange = \_ -> DoNothing, placeholder = Nothing, text = "" }
                       ]
                )

        layoutAttrs =
            [ Border.width 10
            , Font.size 16
            , Font.family []
            ]
    in
    if model.emptyPage then
        layout
            (layoutAttrs
                ++ [ Border.color <| rgb 0 0.7 0 -- green
                   ]
            )
        <|
            content

    else
        layout
            (layoutAttrs
                ++ [ Border.color <| rgb 0 0.7 0.7 -- cyan
                   , htmlAttribute <| Html.Attributes.style "min-height" "0"
                   , inFront content
                   ]
            )
        <|
            none


type alias Flags =
    { x : Int, y : Int, emptyPage : Bool }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Browser.Events.onResize OnResize
        }
