#lang racket

(require racket/gui/easy
         easy-map-widget
         map-widget)


(define (c cx cy r N)
  (build-list N (lambda (x)
                  (vector (+ cx (* r (cos (((2.0 . * . pi) . * . x) . / . N))))
                          (- cy (* r (sin (((2.0 . * . pi) . * . x) . / . N))))))))


(define the-pos (obs (vector 37.984167 23.728056)))
(define points (c (vector-ref (obs-peek the-pos) 0)
                  (vector-ref (obs-peek the-pos) 1) 0.1 16))
(define circle-point-layer (points-layer 'Circle points))
(define circle-line-layer (line-layer 'Lines points))

(define the-zoom (obs 12))
(define the-layers (obs (list circle-point-layer
                              circle-line-layer)))

(define the-map (easy-map-widget the-pos the-zoom the-layers))

(render
 (window
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Map"))


