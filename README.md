# elm-layout

Testing a responsive layout with elm-ui

## Demo

[http://elm-layout.surge.sh/](http://elm-layout.surge.sh/)

## Commands

```
$ npm install
$ cmd/reset
$ cmd/start
$ cmd/surge
```

## Build a responsive layout without CSS

We want to build a responsive layout of a widget. These the requirements:

* Should be full screen on mobile devices
* Should be able to appear above existing webpages
* On larger screen should appear centered
* On larger screen the content underneath should be covered with a dark layer that, when clicked, should close the widget.
* The content should always be scrollable
* Should not rely on the vertical height of the screen, because sometime the height is not reliable

Let's build this in Elm using the elm-ui library.

First let's build the skeleton of "The Elm Architecture". For this prototype we would need some data from Javascript, such as the initial width and height of the screen. We can pass this data using flags. These are the flags:

```
type alias Flags =
    { x : Int
    , y : Int
    , emptyPage : Bool
    , ua : String
    }
```

`x` and `y` are the size of the screen
`emptyPage` tells us if the page is empty or instead has some content
`ua` is to pass the User Agent, a signature of the browser, that we will use just for testing, not to detect the browser or the type of device

The flags will be stored into the model during the initialization of the app. The Model has some extra values:

```
type alias Model =
    { x : Int
    , y : Int
    , emptyPage : Bool
    , ua : String
    , extraContent : Bool
    , enabled : Bool
    , text : String
    }
```

`extraContent` is to toggle more or less content so that we can test both cases.
`enabled` tell us if the widget is enabled or not
`text` is used to type something in the dummy input fields

We are all set.

## Content creation

As first step, let's create the content
