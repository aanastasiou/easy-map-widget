#lang scribble/manual

@require[racket/port
         racket/runtime-path]

@require[@for-label[easy-map-widget
                    racket/base
                    racket/gui/easy
                    racket/gui/easy/contract
                    racket/gui/easy/operator
                    racket/contract
                    map-widget]]

@(define-runtime-path resources "../examples")
@(define (resource a-path)
   (build-path resources a-path))

@; Dump the contents of a file verbatim to a codeblock location
@; Used to include code examples
@(define (dump-verbatim a-path)
   (call-with-input-file (resource a-path) port->string))


@title{easy-map-widget}
@author[(author+email "Athanasios Anastasiou" "athanastasiou@gmail.com" #:obfuscate? #t)]

@defmodule[easy-map-widget]

easy-map-widget is a gui-easy wrapper for map-widget.

@defproc[(easy-map-widget
          [@default-position (obs/c (vectorof number?)) (\@(vector 37.984167 23.728056))]
          [@zoom-level (integer-in 0 20) (\@ 12)]
          [@layers (obs/c (listof (is-a?/c layer<%>))) (\@ '())]
          [@center-on-layer (obs/c (or/c symbol? #f)) (\@ #f)]
          [@resize-to-fit-layer (obs/c (or/c symbol? #f)) (\@ #f)])
         (is-a?/c easy-map-widget<%>)]{

 Returns a @tech{View} of a map widget. This view can then participate in gui-easy user interfaces,
 just like any other gui-easy control. easy-map-widget communnicates with its environment exclusively
 via @tech{Observables}.

 The @racket[default-position] observable sets the position that the map brings at its centre when
 the GUI element is instantiated. This position is a 2 element vector of latitude/longitude values
 in the WGS84 coordinate system.

 The @racket[zoom-level] observable sets the initial zoom level of the map. It takes values between
 0 and 20. Its default value of 12 corresponds approximately to a view that could fit a
 town or city district.

 The @racket[layers] observable sets the @tech{layers} of symbols (markers, lines and other) that are
 depicted on the map widget. This is a list of layers, each of which has a  name associated with it
 that is a symbol.

 The @racket[center-on-layer] observable determines which layer should the map be centered on. A
 value of #f centers the map on all layers. The layer should be specified by name. If the specified
 layer name does not exist in the current list of layers, it is ignored.

 The @racket[resize-to-fit-layer] observable determines which layer should be used to resize the map
 view in order to accomodate it in its entirety. A value of #f uses features from across all layers to
 resize the map view. The layer should be specified by name. If the specified layer name does not
 exist in the current list of layers, it is ignored.}

@section{Usage examples}

@subsection{Depicting a location}

The minimal example is of course to simply depict a location on the map.

This is achieved in the following way:

@codeblock[(dump-verbatim "typical-use.rkt")]

This example creates a simple dialog with a map centered in the city of Athens.

In fact, the definition of @racket[a-map-view] could have been even simpler,
as:

@codeblock{
           (define a-map-view (easy-map-widget))
}

In this case, the map opens by default centered on the Western Australia city of Perth.

Although depicting a static map can be useful, what is more useful is using
a map-view to visualise geospatial data, such as points and boundaries.


@subsection{Visualising geospatial data}

@racket[map-widget] offers a number of different layers to visualise geospatial data
through its layers classes.

@racket[easy-map-widget] re-uses these layers and adds the ability to set and reset them
on a given map through the use of observables.

Almost all of these layers are demonstrated in the following example that is an extension of the
typical use example.

Here, the map widget opens at a default location and a checkbox is used to toggle the depiction of
various geographical features such as points lines and labels.

@codeblock[(dump-verbatim "basic-layers.rkt")]

For more information about the layers please see the @racket[map-widget]
documentation for @racket[line-layer], @racket[lines-layer], @racket[markers-layer] and
@racket[points-layer]

Displaying static features is great but sometimes it is also useful to display dynamic features whose
location might be changing in real-time.

@subsection{Visualising dynamic features}
@racket[map-widget] offers the @racket[current-location-layer] to update the position of one (or more)
markers dynamically.

In this example, we track the position of an unexplained flying object.

@codeblock[(dump-verbatim "current-location-layer.rkt")]

Displaying static and dynamic features is fantastic, but so far, the map's use has been one-way:
from the widget to the user. But some times it is also useful to ask the user for input.

@subsection{Adding interaction}

@codeblock[(dump-verbatim "basic-layers-interaction.rkt")]




