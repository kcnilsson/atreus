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
    ,@(for/list ([s (in-range 24)])
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
                  [true (+ (list-ref column-offsets col)
                           (* spacing row) y-offset)])]
         [r (if (= col 5) 270 0)]
         [label (format "D~a:~a" col row)]
         [diode (+ row (* col 4))])
    (diode-module x y r label
                  `(net ,(+ 11 diode)
                    ,(string->symbol (format "N-diode-~s" diode)))
                  `(net ,(+ row 1)
                        ,(string->symbol (format "N-row-~s" row))))))

(define (column-traces col)
  (let* ([xo (* col spacing)]
         [yo (- (list-ref column-offsets col) 8)])
    (for/list ([coords '[[36.46 22.92 34.23 22.92]
                         [33.02 24.13 33.02 26.67]
                         [34.23 22.92 33.02 24.13]
                         [35.19 44.46 31.75 44.46]
                         [31.75 44.46 31.75 44.45]
                         [31.75 41.91 36.45 41.91]
                         [36.45 41.91 35.19 43.17]
                         [35.19 43.17 35.19 44.46]
                         [36.46 79.92 36.46 81.19]
                         [36.46 81.19 35.19 82.46]
                         [31.75 60.96 36.42 60.96]
                         [36.42 60.96 36.83 60.55]
                         [36.83 60.55 36.83 59.69]
                         [31.75 63.50 35.15 63.50]
                         [35.15 63.50 36.46 62.19]
                         [36.46 62.19 36.46 60.92]
                         [31.75 79.02 35.56 79.02]
                         [35.56 79.02 36.46 79.92]
                         [36.46 22.92 36.46 24.19]
                         [36.46 24.19 35.25 25.40]
                         [35.25 25.40 34.29 25.40]
                         [34.29 25.40 33.02 26.67]
                         [33.02 26.67 31.75 27.94]
                         [31.75 27.94 31.75 41.91]
                         [31.75 41.91 31.75 44.45]
                         [31.75 44.45 31.75 60.96]
                         [31.75 60.96 31.75 63.50]
                         [31.75 63.50 31.75 79.02]
                         [31.75 79.02 35.19 82.46]]])
      (match coords
        [(list xs ys xe ye) `(segment (start ,(+ xo xs) ,(+ yo ys))
                                      (end ,(+ xo xe) ,(+ yo ye))
                                      (width 0.2032) (layer Front)
                                      (net ,(+ col 5)))]))))
(define (row-traces row)
  (let* ([yo (+ (* rows spacing -1) (* (add1 row) spacing))]
         [row3 '[[127.65 58.89 127.65 62.88] ; extra bits for the middle keys
                 [127.00 95.25 125.73 93.98]
                 [140.97 95.25 127.00 95.25]
                 [140.97 68.58 140.97 95.25]
                 [138.43 66.04 140.97 68.58]
                 [130.81 66.04 138.43 66.04]
                 [127.65 62.88 130.81 66.04]
                 [125.73 93.98 125.73 90.17]
                 [123.19 93.98 125.73 93.98]
                 [121.02 91.81 123.19 93.98]
                 [124.09 91.81 125.73 90.17]
                 [125.73 90.17 127.00 88.90]
                 [127.00 87.19 130.19 84.00]
                 [127.00 88.90 127.00 87.19]]]
         [all-rows '[[102.87 86.81 102.87 87.63]
                     [104.14 88.90 105.41 88.90]
                     [102.87 87.63 104.14 88.90]
                     [120.65 91.81 121.02 91.81]
                     [105.00 86.81 105.00 88.49]
                     [105.00 88.49 105.41 88.90]
                     [108.32 91.81 120.65 91.81]
                     [105.41 88.90 108.32 91.81]
                     [120.65 91.81 124.09 91.81]
                     [69.850 85.81 69.130 85.81]
                     [67.310 87.63 65.200 87.63]
                     [69.130 85.81 67.310 87.63]
                     [84.040 82.77 87.630 82.77]
                     [67.000 85.81 69.850 85.81]
                     [69.850 85.81 81.000 85.81]
                     [81.000 85.81 84.040 82.77]
                     [84.040 82.77 86.000 80.81]
                     [48.000 88.81 64.000 88.81]
                     [72.000 80.81 86.000 80.81]
                     [64.000 88.81 72.000 80.81]
                     [86.000 80.81 87.630 82.44]
                     [87.630 82.44 87.630 82.77]
                     [87.630 82.77 87.630 85.09]
                     [89.350 86.81 101.60 86.81]
                     [87.630 85.09 89.350 86.81]
                     [101.60 86.81 102.87 86.81]
                     [102.87 86.81 104.59 86.81]]])
    (for/list ([coords (if (= row 3) (append row3 all-rows) all-rows)])
      (match coords
        [(list xs ys xe ye) `(segment (start ,xs ,(+ yo ys))
                                      (end ,xe ,(+ yo ye))
                                      (width 0.2032) (layer Back)
                                      (net ,(+ row 1)))]))))

(define (diode-traces row col)
  (let* ([xo (* col spacing)]
         [yo (+ (list-ref column-offsets col) -8 (* row spacing))])
    (for/list ([coords '[[48.00 24.19 48.00 23.87]
                         [48.00 23.87 47.05 22.92]
                         [47.05 22.92 41.54 22.92]
                         [41.54 22.92 42.81 24.19]
                         [42.81 24.19 42.81 25.46]
                         [42.81 25.46 44.08 24.19]
                         [44.08 24.19 48.00 24.19]]])
      (match coords
        [(list xs ys xe ye) `(segment (start ,(+ xo xs) ,(+ yo ys))
                                      (end ,(+ xo xe) ,(+ yo ye))
                                      (width 0.2032) (layer Back)
                                      (net ,(+ row (* col 4) 11)))]))))

(define switches+diodes
  (for/list ([col (in-range cols)] #:when true
             [row (if (= 5 col)
                      '(2 3)
                      (in-range rows))])
    (append (list (switch row col) (diode row col))
            (if (= 5 col)
                '()
                (diode-traces row col)))))

(define board
  (apply append nets
         (list (net-class nets))
         (list microcontroller-module)
         (apply append (map column-traces (range (sub1 cols))))
         (apply append (map row-traces (range rows)))
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
      (display ")" op))))

(write-placement "atreus.kicad_pcb")
