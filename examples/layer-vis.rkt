#lang racket

(require racket/gui/easy
         easy-map-widget
         map-widget)


(define (c cx cy r N)
  (build-list N (lambda (x)
                  (vector (+ cx (* r (cos (((2.0 . * . pi) . * . x) . / . N))))
                          (- cy (* r (sin (((2.0 . * . pi) . * . x) . / . N))))))))


(define athens-pos (obs (vector 37.984167 23.728056)))
(define halkida-pos (obs (vector 38.4625 23.595)))

(define points-athens-1 (c (vector-ref (obs-peek athens-pos) 0)
                           (vector-ref (obs-peek athens-pos) 1) 0.1 16))
(define points-athens-2 (c (vector-ref (obs-peek athens-pos) 0)
                           (vector-ref (obs-peek athens-pos) 1) 0.15 32))
(append points-athens-2 (last points-athens-2))

(define points-halkida (c (vector-ref (obs-peek halkida-pos) 0)
                          (vector-ref (obs-peek halkida-pos) 1) 0.1 16))

(define circle-point-layer-athens (points-layer 'AthensDotCircle points-athens-1))
(define circle-line-layer-athens (line-layer 'AthensLineCircle points-athens-2))
(define circle-point-layer-halkida (points-layer 'HalkidaDotCircle points-halkida))

(define the-zoom (obs 11))
(define the-layers (obs (list circle-point-layer-athens
                              circle-line-layer-athens
                              circle-point-layer-halkida)))
(define col (obs #f))
(define rtfl (obs #f))

(define the-map (easy-map-widget athens-pos the-zoom the-layers col rtfl))

;(obs-set! col 'HalkidaCircle)
(render
 (window
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Map"))