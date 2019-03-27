#lang racket

(define cols 6)
(define rows 4)

(define x-offset 20)
(define y-offset 20)

(define spacing 19)
(define angle 0)

(define column-offsets '(8 5 0 6 11 15))

(define (switch-module x y rotation label net-pos net-neg)
  `(module MX_FLIP (layer Front) (tedit 4FD81CDD) (tstamp 543EF801)
    (at ,x ,y ,rotation)
    (path /543DB910)
    (fp_text reference ,label (at 0 3.302 ,rotation) (layer F.SilkS)
             (effects (font (size 1.524 1.778) (thickness 0.254))))
    (fp_line (start -6.35 -6.35) (end 6.35 -6.35)
             (layer F.SilkS) (width 0.381))
    (fp_line (start 6.35 -6.35) (end 6.35 6.35)
             (layer F.SilkS) (width 0.381))
    (fp_line (start 6.35 6.35) (end -6.35 6.35)
             (layer F.SilkS) (width 0.381))
    (fp_line (start -6.35 6.35) (end -6.35 -6.35)
             (layer F.SilkS) (width 0.381))
    (pad 0 np_thru_hole circle (at 0 0) (size 3.9878 3.9878)
         (drill 3.9878)) ; switch hole, no copper
    (pad 0 np_thru_hole circle (at -5.08 0) (size 1.7018 1.7018)
         (drill 1.7018)) ; board-mount hole, no copper
    (pad 0 np_thru_hole circle (at 5.08 0) (size 1.7018 1.7018)
         (drill 1.7018)) ; board-mount hole, no copper
    (pad 1 thru_hole circle (at 2.54 -5.08) (size 2.286 2.286) (drill 1.4986)
         (layers *.Cu *.SilkS *.Mask) ,net-pos)
    (pad 1 thru_hole circle (at 3.81 -2.54) (size 2.286 2.286) (drill 1.4986)
         (layers *.Cu *.SilkS *.Mask) ,net-pos)
    (pad 2 thru_hole circle (at -2.54 -5.08) (size 2.286 2.286) (drill 1.4986)
         (layers *.Cu *.SilkS *.Mask) ,net-neg)
    (pad 2 thru_hole circle (at -3.81 -2.54) (size 2.286 2.286) (drill 1.4986)
         (layers *.Cu *.SilkS *.Mask) ,net-neg)))

(define (diode-module x y rotation label net-pos net-neg)
  `(module DIODE (layer Front) (tedit 4E0F7A99) (tstamp 543EF854)
    (at ,x ,y ,(+ 90 rotation))
    (path /543DB90F)
    (fp_text reference D2:2 (at 0 0 180) (layer F.SilkS) hide
             (effects (font (size 1.016 1.016) (thickness 0.2032))))
    (fp_line (start -1.524 -1.143) (end 1.524 -1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start 1.524 -1.143) (end 1.524 1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start 0 -1.143) (end 0 1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start 0 -1.143) (end -1.524 0)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start -1.524 0) (end 0 1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start 1.524 1.143) (end -1.524 1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start -1.524 1.143) (end -1.524 -1.143)
             (layer F.SilkS) (width 0.2032))
    (fp_line (start -3.81 0) (end -1.6637 0) (layer Back) (width 0.6096))
    (fp_line (start 1.6637 0) (end 3.81 0) (layer Back) (width 0.6096))
    (fp_line (start -3.81 0) (end -1.6637 0) (layer Front) (width 0.6096))
    (fp_line (start 1.6637 0) (end 3.81 0) (layer Front) (width 0.6096))

    (pad 1 thru_hole circle (at -3.81 0 180) (size 1.651 1.651)
         (drill 0.9906) (layers *.Cu *.SilkS *.Mask) ,net-neg)
    (pad 2 thru_hole rect (at 3.81 0 ,rotation) (size 1.651 1.651)
         (drill 0.9906) (layers *.Cu *.SilkS *.Mask) ,net-pos)
    (pad 99 smd rect (at -1.6637 0 ,rotation) (size 0.8382 0.8382)
         (layers Front F.Paste F.Mask))
    (pad 99 smd rect (at -1.6637 0 ,rotation) (size 0.8382 0.8382)
         (layers Back B.Paste B.Mask))
    (pad 99 smd rect (at 1.6637 0 ,rotation) (size 0.8382 0.8382)
         (layers Front F.Paste F.Mask))
    (pad 99 smd rect (at 1.6637 0 ,rotation) (size 0.8382 0.8382)
         (layers Back B.Paste B.Mask))))

(define microcontroller-module
  `(module A_STAR (layer Front) (tedit 4FDC31C8) (tstamp 543EF800)
    (at 134 50 270)
    (path /543EEB02)
    (fp_line (start -15.24 7.62) (end 10.1 7.62) (layer F.SilkS) (width 0.381))

    ;; columns
    (pad B5 thru_hole circle (at -13.97 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 7 N-col-2))
    (pad B4 thru_hole circle (at -11.43 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 8 N-col-3))
    (pad E6 thru_hole circle (at -8.89 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 9 N-col-4))
    (pad D7 thru_hole circle (at -6.35 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 5 N-col-0))
    (pad C6 thru_hole circle (at -3.81 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 6 N-col-1))
    (pad D4 thru_hole circle (at -1.27 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 10 N-col-5))

    ;; rows
    (pad D0 thru_hole circle (at 1.27 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 1 N-row-0))
    (pad D1 thru_hole circle (at 3.81 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 2 N-row-1))
    (pad D3 thru_hole circle (at 6.35 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 3 N-row-2))
    (pad D2 thru_hole circle (at 8.89 6.35 270) (size 1.7526 1.7526)
         (drill 1.0922) (layers *.Cu *.SilkS *.Mask) (net 4 N-row-3))))

(define nets
  `((net 0 "")
    (net 1 N-row-0)
    (net 2 N-row-1)
    (net 3 N-row-2)
    (net 4 N-row-3)
    (net 5  N-col-0)
    (net 6  N-col-1)
    (net 7  N-col-2)
    (net 8  N-col-3)
    (net 9  N-col-4)
    (net 10 N-col-5)
    ,@(for/list ([s (in-range 42)])
        (list 'net (+ 11 s) (string->symbol (format "N-diode-~s" s))))))

(define (net-class nets)
  (append '(net_class Default "This is the default net class."
            (clearance 0.254)
            (trace_width 0.2032)
            (via_dia 0.889)
            (via_drill 0.635)
            (uvia_dia 0.508)
            (uvia_drill 0.127))
          (for/list ([n nets])
            (list 'add_net (last n)))))

(define (switch row col)
  (let* ([x (+ (* (+ 1 col) spacing) x-offset)]
         [y (+ (list-ref column-offsets col) (* spacing row) y-offset)]
         [label (format "SW~a:~a" col row)]
         [diode (+ row (* col 4))]
         [diode-net `(net ,(+ 11 diode)
                      ,(string->symbol (format "N-diode-~s" diode)))]
         [column-net `(net ,(+ col 5)
                       ,(string->symbol (format "N-col-~s" col)))])
    (switch-module x y 0 label diode-net column-net)))

(define (diode row col)
  (let* ([x (if (= col 5)
                134
                (+ (* (+ 1 col) spacing) x-offset 9))]
         [y (cond [(and (= col 5) (= row 2)) 81]
                  [(and (= col 5) (= row 3)) 84]
                  [#t (+ (list-ref column-offsets col) (* spacing row) y-offset)])]
         [r (if (= col 5) 270 0)]
         [label (format "D~a:~a" col row)]
         [diode (+ row (* col 4))])
    (diode-module x y r label
                  `(net ,(+ 11 diode)
                    ,(string->symbol (format "N-diode-~s" diode)))
                  `(net ,(+ row 1)
                    ,(string->symbol (format "N-row-~s" row))))))

(define switches+diodes
  (for/list ([col (in-range cols)] #:when true
             [row (if (or (= 5 col) (= 6 col))
                      '(2 3) (in-range rows))])
    (list (switch row col) (diode row col))))

;; TODO: row bridges
;; TODO: traces

(define board
  (apply append nets
         (list (net-class nets))
         (list microcontroller-module)
         switches+diodes))

(define (write-placement filename)
  (when (file-exists? filename) (delete-file filename))
  (call-with-output-file filename
    (λ (op)
      (display (call-with-input-file "header.rktd"
                 (curry read-string 9999)) op)
      ;; kicad has this terrible bug where it's whitespace-sensitive here =(
      (display "\n" op)
      (for ([f board])
        (pretty-print f op 1))
      ;; TODO: traces!
      (display (call-with-input-file "traces.rktd"
                 (curry read-string 999999)) op)
      (display ")" op))))

(write-placement "atreus.kicad_pcb")
