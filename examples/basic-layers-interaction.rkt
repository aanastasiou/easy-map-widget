#lang racket

(require
  racket/gui
  racket/gui/easy
  easy-map-widget
  map-widget)


; The centre geographical position
(define athens-pos (vector 37.984167 23.728056))

(define points-clicked '())
(define pl (points-layer 'ob points-clicked))


(define iact-layer
  (interaction-layer 'interact
                     (λ (originating-event longitude latitude)
                       (when (send originating-event button-up? 'left)
                         ;(display (format "clicked at ~a ~a" longitude latitude)))
                         (cons (vector longitude latitude) points-clicked))
                         #t)))

; Initialise the map
(define the-zoom (obs 11))
(define def-pos (obs athens-pos))
(define the-layers (obs
                    (list iact-layer
                          pl)))
(define col (obs #f))
(define rtfl (obs #f))

(define the-map (easy-map-widget def-pos
                                 the-zoom
                                 the-layers
                                 col
                                 rtfl))

; Create a modeless window
(render
 (window
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Maps and symbols"))

; resize-to-fit all layers 
(obs-set! rtfl #f)