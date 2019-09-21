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
import Json.Decode


idCover : String
idCover =
    "cover"


type alias Conf =
    { border_rounded : Int
    , layer_1_background_color : Color
    , layer_1_border_color : Color
    , layer_1_border_size : Int
    , layer_2_background_color : Color
    , layer_2_border_color : Color
    , layer_2_border_size : Int
    , layer_3_background_color : Color
    , layer_3_border_color : Color
    , layer_3_border_size : Int
    , layer_4_background_color : Color
    , layer_4_border_color : Color
    , layer_4_border_size : Int
    }


confTesting : Conf
confTesting =
    { layer_1_border_color = rgb 0 0.7 0 -- green
    , layer_1_background_color = rgba 0 0.7 0 0.3 -- green
    , layer_1_border_size = 10
    , layer_2_border_color = rgb 1 0 1 -- purple
    , layer_2_background_color = rgba 1 0 1 0.3 -- purple
    , layer_2_border_size = 10
    , layer_3_border_color = rgba 0.9 0 0 0.5 -- red
    , layer_3_background_color = rgba 0.9 0 0.5 0.3 -- red
    , layer_3_border_size = 10
    , layer_4_border_color = rgb 0.8 0.8 0.0 -- yellow
    , layer_4_background_color = rgba 1 1 0.5 0.8 -- yellow
    , layer_4_border_size = 10
    , border_rounded = 60
    }


confRegular : Conf
confRegular =
    { layer_1_border_color = rgb 1 1 1
    , layer_1_background_color = rgba 0 0 0 0.1
    , layer_1_border_size = 0
    , layer_2_border_color = rgb 1 1 1
    , layer_2_background_color = rgba 0 0 0 0.1
    , layer_2_border_size = 0
    , layer_3_border_color = rgb 0.7 0.7 0.7
    , layer_3_background_color = rgba 1 1 1 1
    , layer_3_border_size = 1
    , layer_4_border_color = rgb 1 1 1
    , layer_4_background_color = rgba 1 1 1 1
    , layer_4_border_size = 0
    , border_rounded = 20
    }


layoutTestingConf : { a | testColors : Bool } -> Conf
layoutTestingConf model =
    if model.testColors then
        confTesting

    else
        confRegular


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
    , testColors : Bool
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
      , testColors = False
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
    | ToggleTesting
    | ChangeText String
    | ClickOnCover MouseClickData


type alias MouseClickData =
    { id1 : String
    , id2 : String
    , id3 : String
    }


clickDecoder : Json.Decode.Decoder MouseClickData
clickDecoder =
    Json.Decode.map3 MouseClickData
        (Json.Decode.at [ "target", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "parentElement", "id" ] Json.Decode.string)


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

        ToggleTesting ->
            ( { model | testColors = not model.testColors }, Cmd.none )

        ChangeHeight y ->
            ( { model | y = Maybe.withDefault 0 (String.toInt y) }, Cmd.none )

        ChangeWidth x ->
            ( { model | x = Maybe.withDefault 0 (String.toInt x) }, Cmd.none )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )

        ClickOnCover mouseClickData ->
            if not model.emptyPage && mouseClickData.id1 == idCover then
                ( { model | enabled = not model.enabled }, Cmd.none )

            else
                ( model, Cmd.none )


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
    [ paddingXY 10 6
    , Border.width 1
    , Border.color <| rgba 0 0 0 0.2
    , Border.rounded 20
    , Background.color <| rgba 1 1 1 0.7
    ]


isTheInnerPartScrollingVertically : Model -> Bool
isTheInnerPartScrollingVertically model =
    not <| isSmallDevice model && model.emptyPage


title : { a | emptyPage : Bool } -> Element msg
title model =
    if model.emptyPage then
        el [ Font.size 30 ] <| text "Empty Page"

    else
        el [ Font.size 30 ] <| text "NOT Empty Page"


layersList : Model -> List ( Color, Color )
layersList model =
    [ ( .layer_1_border_color (layoutTestingConf model), .layer_1_background_color (layoutTestingConf model) ) ]
        -- ++ (if model.emptyPage || isSmallDevice model then
        --         []
        --
        --     else
        --         [ ( .layer_2_border_color (layoutTestingConf model), .layer_2_background_color (layoutTestingConf model) ) ]
        --    )
        ++ (if isSmallDevice model then
                []

            else
                [ ( .layer_3_border_color (layoutTestingConf model), .layer_3_background_color (layoutTestingConf model) ) ]
           )
        ++ [ ( .layer_4_border_color (layoutTestingConf model), .layer_4_background_color (layoutTestingConf model) ) ]


toggleLink : { a | emptyPage : Bool } -> Element msg
toggleLink model =
    if model.emptyPage then
        link buttonAttrs { label = text "NOT Empty Page", url = "index-not-empty.html" }

    else
        link buttonAttrs { label = text "Empty Page", url = "index-empty.html" }


cssToBlockContent : String
cssToBlockContent =
    -- From https://css-tricks.com/prevent-page-scrolling-when-a-modal-is-open/
    -- padding-right: 15px;
    -- position: fixed;
    """
    body {
        height: 100vh;
        overflow-y: hidden;
     }
    """


layer_4 : Model -> Element Msg
layer_4 model =
    column
        ([ paddingXY 30 30
         , spacing 20
         , width (fill |> maximum maxContentWidth)
         , height fill
         , centerX
         , Border.rounded <|
            if isSmallDevice model then
                0

            else
                .border_rounded (layoutTestingConf model)
         , Border.color <| .layer_4_border_color (layoutTestingConf model) -- yellow
         , Background.color <| .layer_4_background_color (layoutTestingConf model) -- yellow
         , Border.width <| .layer_4_border_size (layoutTestingConf model)
         , Border.shadow
            { offset = ( 0, 0 )
            , size = 0
            , blur = 10
            , color = rgba 0 0 0 0.6
            }
         ]
            ++ (if isTheInnerPartScrollingVertically model then
                    [ scrollbarY ]

                else
                    []
               )
        )
        ([ html <| Html.node "style" [] [ Html.text cssToBlockContent ]
         , title model
         , wrappedRow [ spacing 6 ]
            [ Input.button buttonAttrs { onPress = Just ToggleEnabled, label = text "Disable" }
            , Input.button buttonAttrs { onPress = Just ToggleContent, label = text "Extra content" }
            , Input.button buttonAttrs { onPress = Just ToggleTesting, label = text "Test Colors" }
            , toggleLink model
            ]
         , paragraph [] [ text <| "x = " ++ String.fromInt model.x ++ ", y = " ++ String.fromInt model.y ]
         , row [ spacing 20, width fill ]
            [ Input.text [] { label = Input.labelAbove [] <| text "Width", onChange = ChangeWidth, placeholder = Nothing, text = String.fromInt model.x }
            , Input.text [] { label = Input.labelAbove [] <| text "Height", onChange = ChangeHeight, placeholder = Nothing, text = String.fromInt model.y }
            ]
         ]
            ++ (if model.extraContent then
                    [ paragraph []
                        ([ text <| "layers: " ]
                            ++ List.indexedMap
                                (\index colors ->
                                    el
                                        [ Background.color (Tuple.second colors)
                                        , Border.color (Tuple.first colors)
                                        , Border.width 4
                                        , padding 6
                                        ]
                                    <|
                                        text <|
                                            String.fromInt <|
                                                index
                                                    + 1
                                )
                                (layersList model)
                        )
                    , paragraph [] [ text <| "smallDeviceMaxSize = ", text <| String.fromInt smallDeviceMaxSize ]
                    , paragraph [] <|
                        [ text <| "isEmptyPage = "
                        , viewBool model.emptyPage
                        ]
                    , paragraph []
                        [ text <| "isSmallDevice = "
                        , viewBool (isSmallDevice model)
                        ]
                    , paragraph [] [ text <| "isTheInnerPartScrollingVertically = ", viewBool <| isTheInnerPartScrollingVertically model ]
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


view : Model -> Html.Html Msg
view model =
    if not model.enabled then
        Html.button [ Html.Events.onClick ToggleEnabled ] [ Html.text "Enable" ]

    else
        let
            layer_2 =
                layer_3

            layer_3 =
                if isSmallDevice model then
                    layer_4 model

                else
                    el
                        [ width (px maxContentWidth |> maximum (model.x - marginAroundWidgetWhenNotMobile))

                        -- Careful here that sometime when a page is embedded in "custom tabs",
                        -- the vertical height (model.y) can be zero or negative
                        , height (shrink |> maximum (model.y - marginAroundWidgetWhenNotMobile))
                        , centerX
                        , centerY
                        , Border.rounded <| .border_rounded (layoutTestingConf model)
                        , Border.color <| .layer_3_border_color (layoutTestingConf model) -- red
                        , Background.color <| .layer_3_background_color (layoutTestingConf model) -- red
                        , Border.width <| .layer_3_border_size (layoutTestingConf model)
                        ]
                    <|
                        layer_4 model

            layoutAttrs =
                [ Font.size 16
                , Font.family []
                , Border.color <| .layer_1_border_color (layoutTestingConf model) -- green
                , Background.color <| .layer_1_background_color (layoutTestingConf model) -- green
                , Border.width <| .layer_1_border_size (layoutTestingConf model)
                , htmlAttribute <| Html.Attributes.id idCover
                , htmlAttribute <| Html.Events.on "click" (Json.Decode.map ClickOnCover clickDecoder)
                ]
                    ++ (if isSmallDevice model || not model.emptyPage then
                            []

                        else
                            [ Background.image "tokyo.jpg" ]
                       )
                    ++ (if model.emptyPage then
                            []

                        else
                            [ -- Here we want to make the first layer positioned
                              -- absolute at the top. This is not possible in elm-ui
                              -- so we add some CSS
                              htmlAttribute <| Html.Attributes.style "position" "fixed"
                            , htmlAttribute <| Html.Attributes.style "top" "0"
                            ]
                       )
        in
        if model.emptyPage then
            layout layoutAttrs layer_2

        else
            layout (layoutAttrs ++ [ inFront layer_2 ]) <| none


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
