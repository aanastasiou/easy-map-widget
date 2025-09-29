#lang racket

(provide easy-map-widget)

(require racket/gui
         racket/gui/easy
         map-widget)

(define easy-map-widget%
  (class* object% (view<%>)
    (init-field @default-position @zoom-level @layers @center-on-track @resize-to-fit-track)
    (super-new)
    ; Due to the way observables get updated, layer-names preserves
    ; a list of layer names that are already loaded to the map and it is
    ; used when the time comes to remove them.
    (define layer-names '())

    (define/public (dependencies)
      (list @default-position @zoom-level @layers @center-on-track @resize-to-fit-track))

    (define/public (create parent)
      (let [(widget (new map-widget%
                         [parent parent]
                         [position (obs-peek @default-position)]))]
        (send widget begin-edit-sequence)
        (send widget zoom-level (obs-peek @zoom-level))
        (map (lambda (l) (send widget add-layer l)) (obs-peek @layers))
        (set! layer-names (map (lambda (l) (send l get-name)) (obs-peek @layers)))
        (send widget resize-to-fit (obs-peek @resize-to-fit-track))
        (send widget end-edit-sequence)
        widget))

    (define/public (update v what val)
      (send v begin-edit-sequence)
      (case/dep what
        [@zoom-level (send v zoom-level val)]
        [@default-position (send v move-to val)]
        [@layers (map (lambda (l) (send v remove-layer l)) layer-names)
                 (map (lambda (l) (send v add-layer l)) val)
                 (map (lambda (l) (send l get-name)) val)
                 (obs-set! @resize-to-fit-track #f)
                 (obs-set! @center-on-track #f)
      (send v end-edit-sequence))
    
    (define/public (destroy v)
      (void))))

(define (easy-map-widget (p (obs (vector 0.0 0.0)))
                         (z (obs 12))
                         (l (obs '())))
  (new easy-map-widget% [@default-position p] [@zoom-level z] [@layers l]))


;(module+ test
;  (require rackunit)) 
;  
;(module+ test
;  ;; Any code in this `test` submodule runs when this file is run using DrRacket
;  ;; or with `raco test`. The code here does not run when this file is
;  ;; required by another module.
; 
;  (check-equal? (+ 2 2) 4))