#lang racket

(require racket/gui
         racket/gui/easy
         easy-map-widget
         map-widget)

;Produces a list of 2d vectors that represent points on the periphery of a circle
(define (circle-points center-point r N)
  (let ([cx (vector-ref center-point 0)]
        [cy (vector-ref center-point 1)])
    (build-list N (lambda (x)
                    (vector (+ cx (* r (cos (((2.0 . * . pi) . * . x) . / . N))))
                            (- cy (* r (sin (((2.0 . * . pi) . * . x) . / . N)))))))))

; Creates N points on the surface of a disc with center center-point,
; up to r distance way from the center point
(define (fuzzy-disc-points center-point r N)
  (let ([cx (vector-ref center-point 0)]
        [cy (vector-ref center-point 1)])
    (build-list N (lambda (x)
                    (let ([rnd-theta (random 0 N)]
                          [rnd-radius (* r (random))])
                          (vector (+ cx (* rnd-radius
                                           (cos (((2.0 . * . pi) . * . rnd-theta) . / . N))))
                                  (- cy (* rnd-radius
                                           (sin (((2.0 . * . pi) . * . rnd-theta) . / . N))))))))))


; The centre geograhical position
(define athens-pos (vector 37.984167 23.728056))

(define points-athens (fuzzy-disc-points athens-pos 0.005 5000))
(define circle-point-layer-athens (point-cloud-layer 'AthensDotCircle))
(send circle-point-layer-athens add-points points-athens #:format 'lat-lng)
(send circle-point-layer-athens set-color-map (build-list 16 (lambda (x) (make-object color%
                                                                           (exact-round (* (/ x 16) 255))
                                                                           (exact-round (* (/ (- 16 x) 16) 255))
                                                                           0))))
                                                   
; Initialise the map
(define the-zoom (obs 11))
(define def-pos (obs athens-pos))
(define the-layers (obs (list circle-point-layer-athens)))
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