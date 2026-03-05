#lang racket

(require racket/gui
         racket/gui/easy
         easy-map-widget
         map-widget
         "example-utils.rkt")

; The following creates a figure of 8 path
; The centres c1,c2 of the two circles that compose the figure of 8
(define c1 (vector 37.984167 23.728056))
(define c2 (vector (+ 37.984167 0.04) 23.728056))

; Create points on the periphery of two circles
(define points-c1 (circle-points c1 0.02 128))
(define points-c2 (circle-points c2 0.02 128))
; Cut them in half, exchange the halfs and reverse them.
; This effectively creates the figure of 8 path.
(define f8
  (append (append (reverse (take points-c1 64)) (drop points-c2 64))
          (append (take points-c2 64) (reverse (drop points-c1 64)))))                 

; Create the layers that implement the desired behaviour
(define f8-layer (line-layer 'F8 f8))
(define ufo-loc (current-location-layer 'CL))
; Set track-current-location to #t to have the map scroll to keep the current
; location always visible.
(send ufo-loc track-current-location #f)

; Define how the current location is updated
; Here, the marker follows the generated path.
(define current-point-index 0)

(define (draw-target-pos)
  ; Once the current-location gets updated, map-widget redraws a marker at the new location.
  (send ufo-loc current-location (list-ref f8 current-point-index))
  (set! current-point-index (modulo (+ current-point-index 1) (length f8))))
        
; Initialise the map
(define the-default-zoom (obs 11))
(define the-default-position (obs c1))
(define the-default-layers (obs (list f8-layer ufo-loc)))
(define col (obs #f))
(define rtfl (obs #f))

(define a-map-view
  (easy-map-widget the-default-position
                   the-default-zoom
                   the-default-layers
                   col
                   rtfl))

; Create a timer event that will advance the position of the marker every 125ms
(define the-timer
  (new timer% [notify-callback draw-target-pos]
       [interval 125]
       [just-once? #f]))

; Create a modeless window
(render
 (window
  (vpanel
   a-map-view
   #:min-size '(600 400))
  #:title "Maps and symbols"
  ; Stop the timer when the window closes.
  ; The mixin is required to gracefully release the timer before stopping the application
  #:mixin (lambda (x)
            (class x
              (super-new)
              (define (on-close)
                (send the-timer stop))
              (augment on-close)))))

; resize-to-fit-layer all layers 
(obs-set! rtfl #f)
