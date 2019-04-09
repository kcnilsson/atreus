#lang racket
;; Atreus case design mk 4
;; Copyright © 2019 Phil Hagelberg and contributors
;; released under the GPLv3 or later

(require xml)

;; glowforge uses 96 dpi, 25.4 mm in an inch
(define scale (/ 96 25.4))
(define width 260)
(define height 132)


(define cols 6) ; per hand
(define rows 4)
(define angle (degrees->radians 10))
(define corner-radius 6.0)

(define alps-switch-width 15.887)
(define alps-switch-height 13.087)
(define cherry-switch-width 13.62)
(define cherry-switch-height 13.72)
(define cherry? true)
(define switch-height (if cherry? cherry-switch-height alps-switch-height))
(define switch-width (if cherry? cherry-switch-width alps-switch-width))

(define switch-spacing 19.0)

(define screw-radius 1.642) ; for M3 screws

(define side-screw-distance (- (* switch-spacing (+ rows 1)) switch-height))
(define bottom-screw-distance (- (* switch-spacing (+ cols 1)) switch-width))
(define left corner-radius)
(define bottom 95) ; outer bottom
(define left-top (+ left (* side-screw-distance (sin angle))))
(define top (- bottom (* side-screw-distance (cos angle))))
(define right (- width corner-radius))
(define right-top (- right (* side-screw-distance (sin angle))))
(define mid-bottom (+ bottom (* bottom-screw-distance (sin angle))))
(define mid-offset 25)
(define mid-left (- (/ width 2) mid-offset))
(define mid-right (+ (/ width 2) mid-offset))

(define hull-coords (list (list mid-right top)
                          (list right-top top)
                          (list right bottom)
                          (list mid-right mid-bottom)
                          (list mid-left mid-bottom)
                          (list left bottom)
                          (list left-top top)
                          (list mid-left top)))

;;; screws
(define screws
  `(g () ,@(for/list ([s (append (take hull-coords 3)
                                 ;; the bottom middle has only one screw but
                                 ;; two hull positions
                                 (list (list (/ width 2) mid-bottom))
                                 (drop hull-coords 5))])
             `(circle ((r ,(number->string screw-radius))
                       (cx ,(number->string (first s)))
                       (cy ,(number->string (second s))))))))

;;; outline
(define outline-coords (append hull-coords (take hull-coords 2)))

(define (to-next-screw? theta current-screw)
  (let* ([current (list-ref outline-coords current-screw)]
         [cx (first current)] [cy (second current)]
         [next (list-ref outline-coords (add1 current-screw))]
         [nx (first next)] [ny (second next)]
         [dx (- nx cx)] [dy (- ny cy)]
         [next-theta (- (radians->degrees (atan dy dx)))])
    (= (floor (modulo (floor next-theta) 180))
       (floor (modulo (- theta 90) 180)))))

;; trace the outline by going from screw to screw until you've gone full-circle
(define (outline-points coords theta current-screw)
  (if (< -360 (- theta 90) 360)
      (let* ([current (list-ref outline-coords current-screw)]
             [sx (first current)] [sy (second current)]
             [x (+ sx (* (cos (degrees->radians theta)) corner-radius))]
             [y (- sy (* (sin (degrees->radians theta)) corner-radius))]
             [coords (cons (format "~s,~s" x y) coords)])
        (if (to-next-screw? theta current-screw)
            (outline-points coords theta (add1 current-screw))
            (outline-points coords (sub1 theta) current-screw)))
      coords))

(define outline `(polygon
                  ((points ,(string-join (outline-points '() 90 0))))))

;;; switches

(define column-offsets '(8 5 0 6 11 52))

(define (switch row col)
  (let* ([x (* (+ 1 col) switch-spacing)]
         [y (+ (list-ref column-offsets col) (* switch-spacing row))])
    `(rect ((height ,(number->string switch-height))
            (width ,(number->string switch-width))
            (x ,(number->string x))
            (y ,(number->string y))))))

(define hand-height (+ (* switch-spacing rows) (- switch-spacing switch-height)
                       (list-ref column-offsets 0)))
(define switch-x-offset -6)
(define switch-y-offset (- bottom hand-height))

(define switches
  `(g ((transform ,(format "translate(~s, ~s) rotate(~s, ~s, ~s)"
                           switch-x-offset switch-y-offset
                           (radians->degrees angle)
                           0 hand-height)))
      ,@(for/list ([col (in-range cols)]
                   #:when true
                   [row (if (= 5 col) '(0 1) (in-range rows))])
          (switch row col))))

(define switches-right
  `(g ((transform ,(format "translate(~s,~s) scale(-1, 1)" width 0)))
      ,switches))

(define doc
  (document (prolog '() false '())
            (xexpr->xml
             `(svg ((xmlns:svg "http://www.w3.org/2000/svg")
                    (height ,(number->string (* height scale)))
                    (width ,(number->string (* width scale))))
                   (g ((transform ,(format "scale(~s, ~s)" scale scale))
                       (stroke-width "1")
                       (stroke "black")
                       (fill-opacity "0"))
                      ,screws
                      ,outline
                      ,switches
                      ,switches-right
                      )))
            '()))

(call-with-output-file "case-mk4.svg"
  (lambda (out)
    (display "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>" out)
    (display-xml doc out))
  #:exists 'replace)
