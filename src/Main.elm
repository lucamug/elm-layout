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
import Html.Events


smallDeviceMaxSize : Int
smallDeviceMaxSize =
    -- iPhone plus width = 414
    500


maxContentWidth : Int
maxContentWidth =
    smallDeviceMaxSize + 40


marginAroundWidgetWhenNotMobile : Int
marginAroundWidgetWhenNotMobile =
    20 * 2


type alias Model =
    { x : Int
    , y : Int
    , emptyPage : Bool
    , extraContent : Bool
    , enabled : Bool
    , text : String
    , ua : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { x = flags.x
      , y = flags.y
      , emptyPage = flags.emptyPage
      , extraContent = True
      , enabled = True
      , text = ""
      , ua = flags.ua
      }
    , Cmd.none
    )


type Msg
    = DoNothing
    | OnResize Int Int
    | ChangeHeight String
    | ChangeWidth String
    | ToggleContent
    | ToggleEnabled
    | ChangeText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        OnResize x y ->
            ( { model | x = x, y = y }, Cmd.none )

        ToggleContent ->
            ( { model | extraContent = not model.extraContent }, Cmd.none )

        ToggleEnabled ->
            ( { model | enabled = not model.enabled }, Cmd.none )

        ChangeHeight y ->
            ( { model | y = Maybe.withDefault 0 (String.toInt y) }, Cmd.none )

        ChangeWidth x ->
            ( { model | x = Maybe.withDefault 0 (String.toInt x) }, Cmd.none )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )


isSmallDevice : Model -> Bool
isSmallDevice model =
    -- Careful here that sometime when a page is embedded in "custom tabs",
    -- the vertical height (model.y) can be zero or negative
    model.x < smallDeviceMaxSize || model.y < smallDeviceMaxSize


viewBool : Bool -> Element msg
viewBool bool =
    if bool then
        el [ Font.color <| rgb 0 0.5 0 ] <| text "YES"

    else
        el [ Font.color <| rgb 0.8 0 0 ] <| text "NO"


buttonAttrs : List (Attribute msg)
buttonAttrs =
    [ paddingXY 20 8
    , Border.width 1
    , Border.color <| rgba 0 0 0 0.2
    , Border.rounded 20
    , Background.color <| rgba 1 1 1 0.7
    ]


view : Model -> Html.Html Msg
view model =
    if not model.enabled then
        Html.button [ Html.Events.onClick ToggleEnabled ] [ Html.text "Enable" ]

    else
        let
            content_1 =
                if model.emptyPage || isSmallDevice model then
                    content_2

                else
                    el
                        [ Border.width 10
                        , Border.color <| rgb 1 0 1 -- purple
                        , Background.color <| rgba 1 0 1 0.3 -- purple
                        , width fill
                        , height fill
                        ]
                    <|
                        content_2

            content_2 =
                if isSmallDevice model then
                    content_3

                else
                    el
                        [ width (px maxContentWidth |> maximum (model.x - marginAroundWidgetWhenNotMobile))

                        -- Careful here that sometime when a page is embedded in "custom tabs",
                        -- the vertical height (model.y) can be zero or negative
                        , height (shrink |> maximum (model.y - marginAroundWidgetWhenNotMobile))
                        , Border.width 20
                        , Border.color <| rgba 0.9 0 0 0.5 -- red
                        , Border.rounded 60
                        , centerX
                        , centerY
                        , Background.color <| rgba 1 1 0.8 0.7
                        ]
                    <|
                        content_3

            isTheInnerPartScrollingVertically =
                not <| isSmallDevice model && model.emptyPage

            title =
                if model.emptyPage then
                    el [ Font.size 30 ] <| text "Empty Page"

                else
                    el [ Font.size 30 ] <| text "NOT Empty Page"

            toggleLink =
                if model.emptyPage then
                    link buttonAttrs { label = text "NOT Empty Page", url = "index-not-empty.html" }

                else
                    link buttonAttrs { label = text "Empty Page", url = "index-empty.html" }

            content_3 =
                column
                    ([ paddingXY 20 20
                     , spacing 20
                     , width (fill |> maximum maxContentWidth)
                     , height fill
                     , centerX
                     , Border.width 10
                     , Border.color <| rgb 0.8 0.8 0.0 -- yellow
                     , Background.color <| rgba 1 1 0.5 0.8 -- yellow
                     ]
                        ++ (if isTheInnerPartScrollingVertically then
                                [ scrollbarY ]

                            else
                                []
                           )
                    )
                    ([ title
                     , wrappedRow [ spacing 20 ]
                        [ Input.button buttonAttrs { onPress = Just ToggleEnabled, label = text "Disable" }
                        , Input.button buttonAttrs { onPress = Just ToggleContent, label = text "Toggle extra content" }

                        -- , toggleLink
                        ]
                     , paragraph [] [ text <| "x = " ++ String.fromInt model.x ++ ", y = " ++ String.fromInt model.y ]
                     , row [ spacing 20, width fill ]
                        [ Input.text [] { label = Input.labelAbove [] <| text "Width", onChange = ChangeWidth, placeholder = Nothing, text = String.fromInt model.x }
                        , Input.text [] { label = Input.labelAbove [] <| text "Height", onChange = ChangeHeight, placeholder = Nothing, text = String.fromInt model.y }
                        ]
                     ]
                        ++ (if model.extraContent then
                                [ paragraph [] [ text <| "smallDeviceMaxSize = ", text <| String.fromInt smallDeviceMaxSize ]
                                , paragraph [] <|
                                    [ text <| "isEmptyPage = "
                                    , viewBool model.emptyPage
                                    ]
                                , paragraph []
                                    [ text <| "isSmallDevice = "
                                    , viewBool (isSmallDevice model)
                                    ]
                                , paragraph [] [ text <| "isTheInnerPartScrollingVertically = ", viewBool isTheInnerPartScrollingVertically ]
                                , paragraph [] [ text <| "ua = " ++ model.ua ]
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field A", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field B", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field C", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field D", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field E", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                                , Input.text [] { label = Input.labelAbove [] <| text "Field F", onChange = ChangeText, placeholder = Nothing, text = model.text }
                                ]

                            else
                                []
                           )
                    )

            layoutAttrs =
                [ Border.width 10
                , Font.size 16
                , Font.family []
                , Border.color <| rgb 0 0.7 0 -- green
                , Background.color <| rgba 0 0.7 0 0.2 -- green
                ]
        in
        if model.emptyPage then
            layout layoutAttrs content_1

        else
            layout
                (layoutAttrs
                    ++ [ inFront content_1

                       -- This min-height is needed to collapse the main
                       -- container when the page is not empty because
                       -- elm-ui always add "min-height: 100%"
                       , htmlAttribute <| Html.Attributes.style "min-height" "0"
                       ]
                )
            <|
                none


type alias Flags =
    { x : Int
    , y : Int
    , emptyPage : Bool
    , ua : String
    }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Browser.Events.onResize OnResize
        }
