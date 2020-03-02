;; Atreus simulator
;; Copyright © 2020 Phil Hagelberg and contributors
;; released under the GPLv3 or later

;; main.lua:
;; dofile("../fennel/fennel.lua").dofile("sim.fnl", {correlate=true})

(var scale 2.5)
(local width 260)
(local height 150)

(local cols 6) ; per hand
(local rows 4)
(local angle (math.rad 10))
(local corner-radius 8)
(local bottom 100) ; outer bottom

(local switch-height 13.72)
(local switch-width 13.62)
(local switch-spacing 18.6)

;;;; switches
(local offsets [8.0 5.0 0.0 6.0 11.0 15.0])

(local hand-width 106.621)
(local hand-height (+ (* switch-spacing rows) (- switch-spacing switch-height)
                      (. offsets 1)))
(local switch-x-offset (* 1.75 corner-radius))
(local switch-y-offset (- bottom hand-height (-  (math.sqrt corner-radius))))

(local switches-left [])
(local switches-right [])
(local switches-fn-left [])
(local switches-fn-right [])

(local layout-l
       [["'" "," :. :p :y]
        [:a :o :e :u :i]
        [";" :q :j :k :x "`"]
        [:esc :tab :super :lshift :backspace :ctrl]])
(local layout-r
       [[:f :g :c :r :l]
        [:d :h :t :n :s]
        ["\\" :b :m :w :v :z]
        [:alt " " :fn :- :/ "\n"]])

(local layout-fl
       [["!" "@" :up "$" "%"]
        ["(" :left :down :right ")"]
        ["[" "]" "#" "{" "}" "^"]
        [:l2 :insert :super2 :rshift :backspace2 :ctrl2]])

(local layout-fr
       [[:pgup :7 :8 :9 :backspace3]
        [:pgdn :4 :5 :6 :blank]
        ["&" "*" :1 :2 :3 :+]
        [:alt2 :space2 :fn2 :.2 :0 :=]])

(local keys {})

(for [col 1 cols] ; switches
  (for [row 1 rows]
    (when (not (and (= 6 col) (<= row 2)))
      (let [lx (+ (* switch-spacing (- col 1)))
            rx (- (* (- cols 1) switch-spacing) lx)
            y (+ (* switch-spacing (- row 1)) (. offsets col))
            fn-y (+ y bottom)
            kl (table.remove (. layout-l row) 1)
            kr (table.remove (. layout-r row))
            kfl (table.remove (. layout-fl row) 1)
            kfr (table.remove (. layout-fr row))]
        (table.insert switches-left {:x lx :y y :p [] :k kl})
        (table.insert switches-right {:x rx :y y :p [] :k kr})
        (table.insert switches-fn-left {:x lx :y fn-y :p [] :k kfl :fn true})
        (table.insert switches-fn-right {:x rx :y fn-y :p [] :k kfr :fn true})
        (tset keys kl (. switches-left (# switches-left)))
        (tset keys kr (. switches-right (# switches-right)))
        (tset keys kfl (. switches-fn-left (# switches-fn-left)))
        (tset keys kfr (. switches-fn-right (# switches-fn-right)))))))

(fn press [pressed]
  (let [key (. keys (pressed:lower))]
    (when key
      (table.insert key.p {:ox (love.math.randomNormal 2 0)
                           :oy (love.math.randomNormal 2 0)
                           :r (love.math.randomNormal 2 8)})
      (when key.fn
        (press :fn))
      (when (not= pressed (pressed:lower))
        (press :lshift)))))

(var text "The Atreus is a mechanical keyboard designed primarily to match the
shape of human hands and to be as portable as possible. The case
measures 26x12cm and lacks even a number row, relying heavily upon the
=fn= key. There is a circuit board for this design, but it's also
possible to [[http://wiki.geekhack.org/index.php?title=Hard-Wiring_How-To]
[manually wire the matrix]]. ")

(fn tick []
  (when (< 0 (# text))
    (let [key (text:sub 1 1)]
      (press key)
      (set text (text:sub 2)))))

(var t 0)
(fn love.update [dt]
  (set t (+ t dt))
  (when (< 0.2 t)
    (tick)
    (set t 0)))

(fn draw-switch [{: x : y : k : p}]
  (love.graphics.rectangle :line x y switch-width switch-height)
  (when (= (# k) 1)
    (love.graphics.print k (+ x 2) y))
  (love.graphics.setColor 0 0.8 0.9 0.1)
  (each [_ p (ipairs p)]
    (love.graphics.circle :fill
                          (+ x p.ox (/ switch-width 2))
                          (+ y p.oy (/ switch-height 2))
                          p.r))
  (love.graphics.setColor 0 0 0))

(fn love.draw []
  (let [(w h) (love.graphics.getDimensions)]
    (love.graphics.setColor 1 1 1)
    (love.graphics.rectangle :fill 0 0 w h)
    (love.graphics.setColor 0 0 0)
    (love.graphics.scale scale)

    (love.graphics.push)
    (love.graphics.translate (- width hand-width switch-x-offset)
                             switch-y-offset)
    (love.graphics.rotate angle 0 hand-height)
    (love.graphics.translate (- hand-width) 0)
    (each [_ s (pairs switches-left)]
      (draw-switch s))
    (each [_ s (pairs switches-fn-left)]
      (draw-switch s))
    (love.graphics.pop)

    (love.graphics.push)
    (love.graphics.translate (- width hand-width switch-x-offset)
                             switch-y-offset)
    (love.graphics.rotate (- angle))
    (each [_ s (pairs switches-right)]
      (draw-switch s))
    (each [_ s (pairs switches-fn-right)]
      (draw-switch s))
    (love.graphics.pop)))

(fn love.keypressed [key]
  (match key
    "=" (set scale (+ scale 0.2))
    "-" (set scale (- scale 0.2))
    "escape" (love.event.quit)
    "return" (let [fennel (dofile "../fennel/fennel.lua")]
               (fennel.dofile "sim.fnl"))
    key (press key)))
