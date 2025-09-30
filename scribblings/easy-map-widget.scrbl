#lang scribble/manual
@require[@for-label[easy-map-widget
                    racket/base
                    racket/gui/easy]]

@title{easy-map-widget}
@author[(author+email "Athanasios Anastasiou" "athanastasiou@gmail.com" #:obfuscate? #t)]

@defmodule[easy-map-widget]

easy-map-widget is a gui-easy wrapper for map-widget.

@defproc[(easy-map-widget [default-position (maybe-obs/c vector?) '()]) (is-a?/c easy-map-widget<%>)]{

 Returns a representation of a map widget.
}

