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
        (define layers-value (obs-peek @layers))
        (define center-on-layer-value (obs-peek @center-on-layer))
        (define resize-to-fit-value (obs-peek @resize-to-fit-layer))
        
        (send widget begin-edit-sequence)
        (send widget zoom-level (obs-peek @zoom-level))
        ; Add the layers to the map
        (map (lambda (l) (send widget add-layer l)) layers-value)
        ; Keep a list of the layer names
        (set! layer-names (map (lambda (l) (send l get-name)) layers-value))
        ; Before deciding whether to set the layer related info, check if the specified
        ; layer names exist in the list of layer names
        (when (and (not (eq? center-on-layer-value '()))
                   (or (is-in-list? layer-names center-on-layer-value)
                       (eq? center-on-layer-value #f)))
          (send widget center-map (obs-peek @center-on-layer)))
        (when (and (not (eq? resize-to-fit-value '()))
                   (or (is-in-list? layer-names resize-to-fit-value)
                       (eq? resize-to-fit-value #f)))
          (send widget resize-to-fit resize-to-fit-value))
        (send widget end-edit-sequence)
        widget))

    (define/public (update v what val)
      (send v begin-edit-sequence)
      (case/dep what
        [@zoom-level (send v zoom-level val)]
        [@default-position (send v move-to val)]
        [@layers (map (lambda (l) (send v remove-layer l)) layer-names)
                 (map (lambda (l) (send v add-layer l)) val)
                 (set! layer-names (map (lambda (l) (send l get-name)) val))]
        [@center-on-layer (define col-value (obs-peek @center-on-layer))
                          (when (or (is-in-list? layer-names col-value)
                                    (eq? col-value #f))
                            (send v center-map (obs-peek @center-on-layer)))]
        [@resize-to-fit-layer (define rtfl-value (obs-peek @resize-to-fit-layer))
                              (when (or (is-in-list? layer-names rtfl-value)
                                        (eq? rtfl-value #f))
                                (send v resize-to-fit rtfl-value))])
      (send v end-edit-sequence))
    
    (define/public (destroy v)
      (void))))

(define (easy-map-widget (p (obs (vector 0.0 0.0)))
                         (z (obs 12))
                         (l (obs '()))
                         (cl (obs '()))
                         (rl (obs '())))
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