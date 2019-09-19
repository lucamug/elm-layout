module Main exposing (main)

import Element exposing (..)
import Element.Font as Font
import Html


main =
    layout [] <|
        column
            []
            [ paragraph [ spacing 100, Font.color <| rgb 1 0 0 ] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
            , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
            ]
