#lang racket

(require racket/gui
         racket/gui/easy
         racket/gui/easy/contract
         map-widget)

(provide
 (contract-out
  [easy-map-widget easy-map-widget-c]))


(define (is-in-list? lst itm)
  (cond
    [(exact-nonnegative-integer? (index-of lst itm)) #t]
    [else #f]))
  
(define easy-map-widget%
  (class* object% (view<%>)
    (init-field @default-position
                @zoom-level
                @layers
                @center-on-layer
                @resize-to-fit-layer
                [map-widget-cl map-widget%])
    (super-new)
    ; Due to the way observables get updated, layer-names preserves
    ; a list of layer names that are already loaded to the map and it is
    ; used when the time comes to remove them.
    (define layer-names '())

    (define/public (dependencies)
      (list @default-position @zoom-level @layers @center-on-layer @resize-to-fit-layer))

    (define/public (create parent)
      (let [(widget (new map-widget-cl
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
        ; Return the set up widget
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

;(define/contract easy-map-widget+c%
;  (class/c [update (-> (is-a?/c easy-map-widget%) obs? any/c none/c)])
;  easy-map-widget%)

(define (easy-map-widget (@default-position (obs (vector 37.984167 23.728056)))
                         (@zoom-level (obs 12))
                         (@layers (obs '()))
                         (@center-on-layer (obs #f))
                         (@resize-to-fit-layer (obs #f))
                         #:use-widget-class [widget-class map-widget%])
  
  (new easy-map-widget%
       [@default-position @default-position]
       [@zoom-level @zoom-level]
       [@layers @layers]
       [@center-on-layer @center-on-layer]
       [@resize-to-fit-layer @resize-to-fit-layer]
       [map-widget-cl widget-class]))

(define easy-map-widget-c (->* ()
                               ((obs/c (vectorof number?))
                                (obs/c (integer-in 0 20))
                                (obs/c (listof (is-a?/c layer<%>)))
                                (obs/c (or/c symbol? #f))
                                (obs/c (or/c symbol? #f))
                                #:use-widget-class (or/c #f
                                                         (or/c (subclass?/c map-widget%)
                                                               (subclass?/c map-snip%))))
                               (is-a?/c easy-map-widget%)))
                              
(module+ test
  (require rackunit)) 
  
(module+ test
  (test-case
   "easy-map-widget Initialisation"
   (is-a? (easy-map-widget) easy-map-widget%)
   )
  (test-case
   "is-in-list Item found in list"
   (check-eq? (is-in-list? '(1 2 3 4 5) 1) #t)
   (test-case
    "is-in-list Item does not exist in list"
    (check-eq? (is-in-list? '(1 2 3 4 5) 42) #f))))