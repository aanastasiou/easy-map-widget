#lang racket

(provide easy-map-widget)

(require racket/gui
         racket/gui/easy
         map-widget)

(define (is-in-list? lst itm) (cond
                                [(exact-nonnegative-integer? (index-of lst itm)) #t]
                                [else #f]))

; NOTES: The map is initialised with layers
;        If center-on-layer or resize-to-fit-layer exist in the layers, then they are set otherwise
;        they are set to #f if they are not already on #f
;        If either of those parameters is not #f then it is set
;        There should be a difference between #f and '()
(define easy-map-widget%
  (class* object% (view<%>)
    (init-field @default-position @zoom-level @layers @center-on-layer @resize-to-fit-layer)
    (super-new)
    ; Due to the way observables get updated, layer-names preserves
    ; a list of layer names that are already loaded to the map and it is
    ; used when the time comes to remove them.
    (define layer-names '())

    (define/public (dependencies)
      (list @default-position @zoom-level @layers @center-on-layer @resize-to-fit-layer))

    (define/public (create parent)
      (let [(widget (new map-widget%
                         [parent parent]
                         [position (obs-peek @default-position)]))]
        (send widget begin-edit-sequence)
        (send widget zoom-level (obs-peek @zoom-level))
        ; Add the layers to the map
        (map (lambda (l) (send widget add-layer l)) (obs-peek @layers))
        ; Keep a list of the layer names
        (set! layer-names (map (lambda (l) (send l get-name)) (obs-peek @layers)))
        ; Before deciding whether to set the layer related info, check if the specified
        ; layer names exist in the list of layer names
        (when (not (is-in-list? layer-names (obs-peek @center-on-layer)))
          (obs-set! @center-on-layer #f))
        (send widget center-map (obs-peek @center-on-layer))
        (when (not (is-in-list? layer-names (obs-peek @resize-to-fit-layer)))            
            (obs-set! @resize-to-fit-layer #f))
        (send widget resize-to-fit (obs-peek @resize-to-fit-layer))
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
                 (obs-set! @resize-to-fit-layer #f)
                 (obs-set! @center-on-layer #f)]
        [@center-on-layer (send v center-map (obs-peek @center-on-layer))]
        [@resize-to-fit-layer (send v resize-to-fit (obs-peek @resize-to-fit-layer))])
      (send v end-edit-sequence))
    
    (define/public (destroy v)
      (void))))

(define (easy-map-widget (p (obs (vector 0.0 0.0)))
                         (z (obs 12))
                         (l (obs '()))
                         (cl (obs #f))
                         (rl (obs #f)))
  (new easy-map-widget% [@default-position p] [@zoom-level z] [@layers l] [@center-on-layer cl] [@resize-to-fit-layer rl]))


;(module+ test
;  (require rackunit)) 
;  
;(module+ test
;  ;; Any code in this `test` submodule runs when this file is run using DrRacket
;  ;; or with `raco test`. The code here does not run when this file is
;  ;; required by another module.
; 
;  (check-equal? (+ 2 2) 4))