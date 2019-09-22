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

## Build a responsive layout without a line of CSS

This is a tutorial on how to build a mildly complex web layout without any knowledge of CSS (and also any knowledge of Javascript and HTML for that matter).

The layout is built using Elm and elm-ui. Elm is a pure functional language that compile to Javascript. elm-ui is an Elm library that create a semantic layer on top of CSS and HTML.

The end result is:

## The task

We want to build a responsive layout of a [modal window](https://en.wikipedia.org/wiki/Modal_window) working both on __small__ and __large__ screens.

A __small screen__ is defined as any screen where either the height or the width are smaller than a set size. We use 500 px as reference.

Here you can see how the iPhone plus (414 x 736 px) fit in this definition:

        414 x 736
        ┌─────────────┐
        │             │
      500 x 500       │    
      ╔═╪═════════════╪═╗
┌─────╫─┼─────────────┼─╫─────┐
│     ║ │             │ ║     │
│     ║ │             │ ║     │
│     ║ │             │ ║     │
│     ║ │             │ ║     │
│ 736 x 414           │ ║     │
└─────╫─┼─────────────┼─╫─────┘
      ╚═╪═════════════╪═╝
        │             │    
        │             │    
        └─────────────┘

# The requirements

* On __large screen__
    * should appear centered vertically and horizontally
    * should have a set maximum width
    * should have a maximum height of the screen size minus 40 px (20 px above and 20 px below)
    * vertical height should shrink to the content
    * the inner part should be scrollable if the content is small
    * on NON-empty pages the content underneath should be covered with a dark layer that, when clicked, should close the widget
    * on empty pages the modal should be floating above an image
* On __small screen__ (like mobile phones)
    * The modal should go from top to bottom of the screen
    * the content should be top aligned in case is small
    * should have a set maximum width
    * on empty pages there should be a gray layer beneath (no background image)
    * on NON-empy pages, the content underneath should be visible is the screen is wider that the modal (like in landscape orientation)
* it should graceful degrade in case window.innerHeight returns zero or negative numbers (it seems happening when using [Chrome Custom Tabs](https://developer.chrome.com/multidevice/android/customtabs))

## The execution

Let's start from the most inner part:







```
isSmallDevice model =
    model.x < smallDeviceMaxSize || model.y < smallDeviceMaxSize
```



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
