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


(define c1 (vector 37.984167 23.728056))
(define c2 (vector (+ 37.984167 0.04) 23.728056))
  
(define points-c1 (circle-points c1 0.02 128))
(define points-c2 (circle-points c2 0.02 128))
(define f8 (append (append (reverse (take points-c1 64)) (drop points-c2 64))
                   (append (take points-c2 64) (reverse (drop points-c1 64)))))                 
(define f8-layer (line-layer 'F8 f8))
(define my-loc (current-location-layer 'CL))

(define current-point-index 0)

(define (reset-and-draw)
  (send my-loc current-location (list-ref f8 current-point-index))
  (set! current-point-index (let ([future-value (+ current-point-index 1)])
                              (if (> future-value (length f8))
                                  0
                                  future-value))))
       
  

; Initialise the map
(define the-zoom (obs 11))
(define def-pos (obs c1))
(define the-layers (obs (list f8-layer my-loc)))
(define col (obs #f))
(define rtfl (obs #f))

(define the-map (easy-map-widget def-pos
                                 the-zoom
                                 the-layers
                                 col
                                 rtfl))

(new timer% [notify-callback reset-and-draw]
       [interval 125]
       [just-once? #f])

; Create a modeless window
(render
 (window
  (vpanel
   the-map
   #:min-size '(600 400))
  #:title "Maps and symbols"))

; resize-to-fit all layers 
(obs-set! rtfl #f)

