#lang racket

(provide easy-map-widget)

(require racket/gui
         racket/gui/easy
         racket/gui/easy/contract
         map-widget)

(define (is-in-list? lst itm) (cond
                                [(exact-nonnegative-integer? (index-of lst itm)) #t]
                                [else #f]))

  
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
        
        (send widget begin-edit-sequence)
        (send widget zoom-level (obs-peek @zoom-level))
        ; Add the layers to the map
        (map (lambda (l) (send widget add-layer l)) layers-value)
        ; Keep a list of the layer names
        (set! layer-names (map (lambda (l) (send l get-name)) layers-value))
        (send widget end-edit-sequence)
        widget))

    (define (center-resize-to-layer widget @value-obs operation)
      (define centering-value (obs-peek @value-obs))
      (when (or (is-in-list? layer-names centering-value)
                (eq? centering-value #f))
        (case operation
          ['center (send widget center-map centering-value)]
          ['resize (send widget resize-to-fit centering-value)])))

    (define/public (update v what val)
      (send v begin-edit-sequence)
      (case/dep what
        [@zoom-level (send v zoom-level val)]
        [@default-position (send v move-to val)]
        [@layers (map (lambda (l) (send v remove-layer l)) layer-names)
                 (map (lambda (l) (send v add-layer l)) val)
                 (set! layer-names (map (lambda (l) (send l get-name)) val))]
        [@center-on-layer (center-resize-to-layer v @center-on-layer 'center)]
        [@resize-to-fit-layer (center-resize-to-layer v @resize-to-fit-layer 'resize)])
      (send v end-edit-sequence))
    
    (define/public (destroy v)
      (void))))

(define (easy-map-widget (@default-position (obs (vector 37.984167 23.728056)))
                         (@zoom-level (obs 12))
                         (@layers (obs '()))
                         (@center-on-layer (obs #f))
                         (@resize-to-fit-layer (obs #f)))
  
  (new easy-map-widget%
       [@default-position @default-position]
       [@zoom-level @zoom-level]
       [@layers @layers]
       [@center-on-layer @center-on-layer]
       [@resize-to-fit-layer @resize-to-fit-layer]))

(define easy-map-widget-c (-> (obs/c (vectorof number?))
                              (obs/c exact-nonnegative-integer?)))


;(module+ test
;  (require rackunit)) 
;  
;(module+ test
;  ;; Any code in this `test` submodule runs when this file is run using DrRacket
;  ;; or with `raco test`. The code here does not run when this file is
;  ;; required by another module.
; 
;  (check-equal? (+ 2 2) 4))