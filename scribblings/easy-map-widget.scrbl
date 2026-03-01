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

@codeblock[(dump-verbatim "typical-use.rkt")]

@subsection{Visualising geographical features}

@codeblock[(dump-verbatim "basic-layers.rkt")]

@subsubsection{Visualising geographical distribution}

@codeblock[(dump-verbatim "cloud-point-layer.rkt")]

@subsection{Visualising dynamic features}

@codeblock[(dump-verbatim "current-location-layer.rkt")]

@subsection{Adding interaction}

@codeblock[(dump-verbatim "basic-layers-interaction.rkt")]




