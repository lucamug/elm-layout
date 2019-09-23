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

## Build a responsive layout without a single line of CSS

This is a tutorial on how to build a mildly complex web layout without any knowledge of CSS (and also any knowledge of Javascript and HTML for that matter).

The layout is built using Elm and elm-ui. Elm is a pure functional language that compile to Javascript. elm-ui is an Elm library that create a semantic layer on top of CSS and HTML. If you are now to Elm, the [Elm official guide](https://guide.elm-lang.org/) and the [elm-ui documentation](https://package.elm-lang.org/packages/mdgriffith/elm-ui/1.1.0/) are two good places where to start.

The end result of this tutorial is at:

## The task

We want to build a responsive layout of a [modal window](https://en.wikipedia.org/wiki/Modal_window) working both on __small window__ and __large window__.

# The requirements

* On __large window__
    * should appear centered vertically and horizontally
    * should have a set maximum width
    * should have a maximum height of the screen size minus 40 px (20 px above and 20 px below)
    * vertical height should shrink to the content
    * the inner part should be scrollable if the content is small
    * on NON-empty pages the content underneath should be covered with a dark layer that, when clicked, should close the widget
    * on empty pages the modal should be floating above an image

* On __small window__ (this is the case of mobile phones)
    * The modal should go from top to bottom of the screen
    * the content should be top aligned in case is small
    * should have a set maximum width
    * on empty pages there should be a gray layer beneath (no background image)
    * on NON-empty pages the content underneath should be covered with a dark layer that, when clicked, should close the widget

* The concept of __empty page__ and __NON empty page__ are passed to the application using a configuration flag. The idea is that this layout can work on both cases but it needs to be aware of it. In the demo that I set up I am adding and removing the original content of the page on the fly, sending a command through a port. In a real scenario this would not be needed.

* We should minimize the complexity of the layout. For example in case of a __small screen__ and an __empty page__ we should avoid the inner div to scroll as some mobile browser are still struggling with scrolling divs.

* I also setup several switches that are useful during the development phase:

    * Disable/Enable - This would turn off the entire layout replacing with a "Enable Modal" button. It has the effect of closing the modal. It has no much sense in case of __empty page__ but it is meaningful for a __NON empty page__.
    * More/Less content - This hide or add extra content inside the modal, to test both cases.
    * Test/Normal colors -  This add extra color to the main 2~3 layers of the layout to make the development clearer.
    * Empty/NON empty page - This remove/add the content in the host page and at the same time toggle the way of working of the modal.
    * Width/Height/Margin input fields - Using these is possible to manually change this data. Consider that on resize the browser windows they width and height are reset. The other input fields are fake.

## The execution

The code is hopefully self-explanatory. I want to give you here some of the main concept about the implementation logic.

### isSmallWindow

__isSmallWindow__ is a boolean value that is set to true if the user has a small screen. Not that we are not talking about __isMobile__ because detecting if it is a mobile is trickier and is not what we need to know.

A __small window__ is defined as any window where either the height or the width are smaller than a set size. We use 500 px as reference.

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


The logic is:

```
isSmallDevice model =
    model.x < smallDeviceMaxSize || model.y < smallDeviceMaxSize
```

### isTheInnerPartUnscrollable

This is telling us if the inner part of the modal need to be scrollable.

The logic is

```
isTheInnerPartUnscrollable model =
    isSmallWindow model && model.isEmptyPage
```

that is telling us that the only case when the inner part of the modal don't need to scroll is when the window is small and the page is empty.


### isBackgroundImageUnnecessary

The layout should not load the background image what that is not necessary. This is resolved by the logic

```
isBackgroundImageUnnecessary model =
    isSmallWindow model || not model.isEmptyPage
```

so the only case when the background image should load is when the window is large and the page is empty

## The Inner Part - layer_modal

Now that the small logic components are built, we can use them to create the skeleton of the layout.

The attributes part of this layer (function `layer_modal_attrs`) need to take in consideration the scrollability:

```
scrollbarY_attr =
    if isTheInnerPartUnscrollable model then
        []

    else
        [ scrollbarY ]
```
also, if the window is small, we remove the roundness because the corners are reaching the edge of the window now and it would look weird is they are still rounded:

```
borderRounded_attr =
    if isSmallWindow model then
        []

    else
        [ Border.rounded <| .border_rounded (layoutTestingConf model) ]

```

The content part (function `layer_modal_content`) is quite straightforward. It contains all regular content for the demo to work such as buttons, input fields, dummy text, etc.

Moreover it has two small css tricks (did I say "without a single line of CSS"? Ooops!)

`extraCss1` contains the trick to [prevent the background page from scrolling when the modal is open](https://css-tricks.com/prevent-page-scrolling-when-a-modal-is-open/).

`extraCss2` contains the trick that [add the momentum scrolling on iOS in overflow elements](https://css-tricks.com/snippets/css/momentum-scrolling-on-ios-overflow-elements/).

As you can see, in case some CSS trick is still needed, it is trivial to add them.

## The main View

The main view (function `view`) contain the rest of the logic:

### The layer_modal_rounded

If we are on a __large window__ we add an extra layer with rounded border (`layer_modal_rounded`). This will contain the `layer_modal` created above making it scrolling vertically. The important attributes for this extra layer are:

```
[ width (px (maxContentWidth model) |> maximum (model.x - model.marginAroundWidgetWhenNotMobile))
, height (shrink |> maximum (model.y - model.marginAroundWidgetWhenNotMobile))
, centerX
, centerY
, Border.rounded <| .border_rounded (layoutTestingConf model)
...
]
```

The maximum width and height depend on the width and height of the window, this assure the presence of margins.
The width is set as the `maxContentWidth = smallDeviceMaxSize = 500px`
The height is shrinking to wrap nicely the content, in case the content is limited.
The section is centered horizontally and vertically.

### The rest

This is the time to add the background image if needed:

```
if isBackgroundImageUnnecessary model then
    []

else
    [ Background.image "http://elm-layout2.surge.sh/tokyo.jpg" ]
```

If it is a __NON empty page__ we want to block the main layer at the top of the page. For this we add two extra CSS attributes because `elm-ui` doesn't have this option:

```
if model.isEmptyPage then
    []

else
    [ htmlAttribute <| Html.Attributes.style "position" "fixed"
    , htmlAttribute <| Html.Attributes.style "top" "0"
    ]
```

And finally we put everything together in two different ways:

```
if model.isEmptyPage then
    layout layoutAttrs layer_modal_rounded

else
    layout (layoutAttrs ++ [ inFront layer_modal_rounded ]) <| none
```

If it is an __empty page__ we just add `layer_modal_rounded` the normal way. Otherwise is add it as `inFront`.

Done, our layout is ready.

What do you think about this process of creating web pages? Do you think it could be done better or simpler? Leave your comments below.
