#lang racket

; A browser of the top 10 largest cities in the world by
; population as ranked in:
; https://en.wikipedia.org/wiki/List_of_largest_cities

(require racket/gui
         racket/gui/easy
         easy-map-widget
         map-widget)

(define data (list (list "Tokyo" (vector 35.689722 139.692222))
                   (list "Delhi" (vector 28.61 77.23))
                   (list "Shanghai" (vector 31.228611 121.474722))
                   (list "São Paulo" (vector -23.55 -46.633333))
                   (list "Mexico City" (vector 19.433333 -99.133333))
                   (list "Cairo" (vector 30.044444 31.235833))
                   (list "Mumbai" (vector 19.433333 -99.133333))
                   (list "Beijing" (vector 39.906667 116.3975))
                   (list "Dhaka" (vector 23.764444 90.388889))
                   (list "Osaka" (vector 34.693889 135.502222))))

(define zoom-levels (list (list "Near" 14)
                          (list "Far" 7)
                          (list "World view" 2)))


; Initialise the map
(define the-zoom (obs (second (first zoom-levels))))
(define def-pos (obs (second (first data))))
; No layers for this application
(define the-layers (obs '()))
(define col (obs #f))
(define rtfl (obs #f))

; The map widget embedded in a panel to allow fine control of its size
(define map-widget-size
  (hpanel
   #:min-size '(600 400)
   (easy-map-widget def-pos
                    the-zoom
                    the-layers
                    col
                    rtfl)))

; The main application user interface
(define app-dialog
  (vpanel
   (vpanel
    (hpanel
     (choice (map first zoom-levels) (lambda (x) (obs-set! the-zoom (second (assoc x zoom-levels)))))
     (choice (map (lambda (x) (first x)) data)
             (lambda (x) (obs-set! def-pos (second (assoc x data))))))
    map-widget-size)))

(render
 (dialog
  app-dialog
  #:title "Largest cities in the world by population"))