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

(define points-athens (c (vector-ref (obs-peek athens-pos) 0)
                         (vector-ref (obs-peek athens-pos) 1) 0.1 16))

(define points-halkida (c (vector-ref (obs-peek halkida-pos) 0)
                          (vector-ref (obs-peek halkida-pos) 1) 0.1 16))

(define circle-point-layer-athens (points-layer 'AthensCircle points-athens))
(define circle-point-layer-halkida (points-layer 'HalkidaCircle points-halkida))

(define the-zoom (obs 9))
(define the-layers (obs (list circle-point-layer-athens
                              circle-point-layer-halkida)))
(define col (obs '()))
(define rtfl (obs 'AthensCircle))

(define the-map (easy-map-widget athens-pos the-zoom the-layers col rtfl))
(obs-set! rtfl 'AthensCircle)

;(obs-set! col 'HalkidaCircle)
(render
 (window
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Map"))