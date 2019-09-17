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


mobileMaxWidth : Int
mobileMaxWidth =
    -- iPhone plus width = 414
    420


maxContentWidth : Int
maxContentWidth =
    mobileMaxWidth + 80


marginAroundWidgetWhenNotMobile : Int
marginAroundWidgetWhenNotMobile =
    40 * 2


type alias Model =
    { x : Int
    , y : Int
    , emptyPage : Bool
    , longContent : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { x = flags.x
      , y = flags.y
      , emptyPage = flags.emptyPage
      , longContent = True
      }
    , Cmd.none
    )


type Msg
    = DoNothing
    | OnResize Int Int
    | ChangeHeight String
    | ToggleContent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        OnResize x y ->
            ( { model | x = x, y = y }, Cmd.none )

        ToggleContent ->
            ( { model | longContent = not model.longContent }, Cmd.none )

        ChangeHeight y ->
            ( { model | y = Maybe.withDefault 0 (String.toInt y) }, Cmd.none )


isMobile : Model -> Bool
isMobile model =
    -- Careful here that sometime when a page is embedded in "custom tabs",
    -- the vertical height (model.y) can be zero or negative
    model.x < mobileMaxWidth || model.y < mobileMaxWidth


viewBool : Bool -> Element msg
viewBool bool =
    if bool then
        el [ Font.color <| rgb 0 0.5 0 ] <| text "YES"

    else
        el [ Font.color <| rgb 0.8 0 0 ] <| text "NO"


view : Model -> Html.Html Msg
view model =
    let
        content =
            if isMobile model then
                innerContent

            else
                el
                    [ width (px maxContentWidth |> maximum (model.x - marginAroundWidgetWhenNotMobile))

                    -- Careful here that sometime when a page is embedded in "custom tabs",
                    -- the vertical height (model.y) can be zero or negative
                    , height (shrink |> maximum (model.y - marginAroundWidgetWhenNotMobile))
                    , Border.width 20
                    , Border.color <| rgb 1 0.9 0.0 -- yellow
                    , Border.rounded 40
                    , centerX
                    , centerY
                    , Background.color <| rgba 1 1 0.8 0.7
                    ]
                <|
                    innerContent

        scrollbarY_ =
            not <| isMobile model && model.emptyPage

        title =
            if model.emptyPage then
                el [ Font.size 30 ] <| text "Empty Page"

            else
                el [ Font.size 30 ] <| text "NOT Empty Page"

        toggleLink =
            if model.emptyPage then
                link [] { label = text "Go to NOT Empty Page", url = "index.html" }

            else
                link [] { label = text "Go to Empty Page", url = "index-empty.html" }

        innerContent =
            column
                ([ paddingXY 20 20
                 , spacing 20
                 , width (fill |> maximum maxContentWidth)
                 , centerX
                 , Border.width 10
                 , Border.color <| rgb 1 0 0 -- Border red
                 , Background.color <| rgba 1 1 0.8 0.9 -- Yellow background
                 ]
                    ++ (if scrollbarY_ then
                            [ scrollbarY ]

                        else
                            []
                       )
                )
                [ title
                , paragraph [] [ text <| "mobileMaxWidth = ", text <| String.fromInt mobileMaxWidth ]
                , paragraph [] <|
                    [ text <| "isEmptyPage = "
                    , viewBool model.emptyPage
                    , text " ("
                    , toggleLink
                    , text ")"
                    ]
                , paragraph [] [ text <| "x = " ++ String.fromInt model.x ++ ", y = " ++ String.fromInt model.y ]
                , paragraph []
                    [ text <| "isMobile = x < "
                    , text <| String.fromInt mobileMaxWidth
                    , text <| " || y < "
                    , text <| String.fromInt mobileMaxWidth
                    , text <| " = "
                    , viewBool (isMobile model)
                    ]
                , paragraph [] [ text <| "isScrollbarY = not <| isMobile && isEmptyPage = ", viewBool scrollbarY_ ]
                , Input.text [] { label = Input.labelAbove [] <| text "Height", onChange = ChangeHeight, placeholder = Nothing, text = String.fromInt model.y }
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

        layoutAttrs =
            [ Border.width 10
            , Font.size 16
            , Font.family []
            , Border.color <| rgb 0 0.7 0 -- green
            ]
    in
    if model.emptyPage then
        layout layoutAttrs content

    else
        layout
            (layoutAttrs
                ++ [ inFront content

                   -- This min-height is needed to collapse the main
                   -- container when the page is not empty because
                   -- elm-ui always add "min-height: 100%"
                   , htmlAttribute <| Html.Attributes.style "min-height" "0"
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
