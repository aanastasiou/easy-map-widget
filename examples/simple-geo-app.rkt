#lang racket

(require racket/gui
         racket/gui/easy
         easy-map-widget
         map-widget)

(define data (list (list "Tokyo" (vector 35.689722 139.692222))
                   (list "Delhi" (vector 28.61 77.23))
                   (list "Shanghai" (vector 31.228611 121.474722))
                   (list "São Paulo" (vector -23.55 -46.633333))
                   (list "Mexico City" (vector 19.433333 -99.133333))))

(define zoom-levels (list (list "Near" 14)
                          (list "Far" 7)))


; Initialise the map
(define the-zoom (obs (second (first zoom-levels))))
(define def-pos (obs (second (first data))))
(define the-layers (obs '()))
(define col (obs #f))
(define rtfl (obs #f))

(define map-widget-size
  (hpanel
   #:min-size '(600 400)
   (easy-map-widget def-pos
                    the-zoom
                    the-layers
                    col
                    rtfl)))

(define app-dialog
  (vpanel
   (vpanel
    (hpanel (choice '("Near" "Far") (lambda (x) (obs-set! the-zoom (second (assoc x zoom-levels)))))
            (choice (map (lambda (x) (first x)) data)
                    (lambda (x) (obs-set! def-pos (second (assoc x data))))))
    map-widget-size)))

(render
 (dialog
  app-dialog
  #:title "Top 5 largest cities"))