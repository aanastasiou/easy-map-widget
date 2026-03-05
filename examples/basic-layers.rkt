#lang racket

(require racket/gui
         racket/gui/easy
         easy-map-widget
         map-widget
         "example-utils.rkt")

; The geographical position at the centre for this demo.
(define athens-pos (vector 37.984167 23.728056))

; A points layer associates a point marker with each geographical location
; as defined by a list of 2d vectors. Here, 16 points around the centre point
(define points-athens-1 (circle-points athens-pos 0.1 16))
(define circle-point-layer-athens (points-layer 'AthensDotCircle points-athens-1))

; A line (sic) layer creates a boundary by connecting a series of points with a continuous
; line, from point to point. Here, the boundary is closed (the first and last points
; coincide)
(define points-athens-2 (let ([temp-points (circle-points athens-pos 0.15 32)])
                          (append temp-points
                                  (list (first temp-points)))))
(define circle-line-layer-athens (line-layer 'AthensLineCircle points-athens-2))

; A lines (sic) layer creates disjoint boundaries as these are defined by a list of
; lists of 2d vectors. Here, 8 line segments are created by producing 8 lists
; of two vector lists, each of which begins at the centre point and extends out
; to the cardinal and intercardinal points.
(define points-athens-3 (circle-points athens-pos 0.07 8))
(define circle-lines-layer-athens (lines-layer 'AthensLinesCircle
                                               (map (lambda (u v) (list u v))
                                                    (build-list (length points-athens-3)
                                                                (lambda (x) athens-pos))
                                                    points-athens-3)))

; The colour of labels that is used for the labels layer.
(define lbl-clr (make-object color% 32 255 32))

; A labels layer is used to add labels to specific points on a map.
(define label-info (list
                    (list (first points-athens-1) "points-layer" 1 lbl-clr)
                    (list (first points-athens-2) "line-layer" 1 lbl-clr)
                    (list (first points-athens-3) "lines-layer" 1 lbl-clr)))

(define labels-layer (markers-layer 'AthensLayerDesc label-info))

; Initialise the map
(define the-default-zoom (obs 11))
(define the-default-position (obs athens-pos))

;(define the-default-layers (obs (list circle-point-layer-athens
;                                      circle-line-layer-athens
;                                      circle-lines-layer-athens
;                                      labels-layer)))

(define the-default-layers (obs '()))

; Parameters that direct the map where to focus on and to what extent
(define col (obs #f))
(define rtfl (obs #f))

; Initialisation of the map view
(define a-map-view (easy-map-widget the-default-position
                                    the-default-zoom
                                    the-default-layers
                                    col
                                    rtfl))

(define app-view
  (vpanel
   (checkbox
    (λ (checked?)      
      (obs-set! the-default-layers (or
                                    (and checked? (list circle-point-layer-athens
                                                        circle-line-layer-athens
                                                        circle-lines-layer-athens
                                                        labels-layer))
                                    '()))
      (if checked?
          (obs-set! rtfl #f)
          (void)))
    #:label "Display geospatial information")
   a-map-view))

(render
 (dialog
  (vpanel
   app-view
   #:min-size '(600 400))
  #:title "Maps and symbols"))