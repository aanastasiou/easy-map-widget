#lang racket

(provide circle-points)

;Produces a list of 2d vectors that represent points on the periphery of a circle
(define (circle-points center-point r N)
  (let ([cx (vector-ref center-point 0)]
        [cy (vector-ref center-point 1)])
    (build-list N (lambda (x)
                    (vector (+ cx (* r (cos (((2.0 . * . pi) . * . x) . / . N))))
                            (- cy (* r (sin (((2.0 . * . pi) . * . x) . / . N)))))))))

