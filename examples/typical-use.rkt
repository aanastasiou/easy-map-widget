#lang racket

(require racket/gui/easy
         easy-map-widget)

; The default position of the map is expressed as a vector
; Furthermore, that vector is expressed here as an observable
(define the-default-position (obs (vector 37.984167 23.728056)))

; The same applies to the default zoom the map should open at
(define the-default-zoom (obs 12))

; The actual initialisation of easy-map-widget.
; This returns a view that displays a map.
(define a-map-view (easy-map-widget the-default-position the-default-zoom))

; Create a dialog box of dimensions 600 x 400 to render just the one
; map view configured in this example.
(render
 (dialog
  (vpanel
   a-map-view
   #:min-size '(600 400))
  #:title "Map"))
