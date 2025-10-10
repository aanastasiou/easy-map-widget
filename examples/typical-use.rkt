#lang racket

(require racket/gui/easy
         easy-map-widget)

(define the-pos (obs (vector 37.984167 23.728056)))
(define the-zoom (obs 12))

(define the-map (easy-map-widget the-pos the-zoom))

(render
 (dialog
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Map"))
