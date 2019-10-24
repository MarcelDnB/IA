;----------------- Include Algorithms Library --------------------------------

__includes [ "A-star.nls" "LayoutSpace.nls"]

to-report movements [h]
  let resp []
  let aux []
  set aux lput (range n) aux
  foreach n [set resp lput aux resp]
  report item h resp
end

; For a given state s, (swap i j s) returns a new state where tiles in
; positions i and j have been swapped
to-report swap [i j s]
  let old-i item i s
  let old-j item j s
  let s1 replace-item i s old-j
  let s2 replace-item j s1 old-i
  report s2
end


to-report AI:children-states
  let i (position 0 content)
  let indexes (movements i)
  report (map [ x -> (list (swap i x content) (list (word "T-" x) 1 "regla")) ] indexes)
end

to-report AI:final-state? [params]
  report ( content = params)
end

to-report suma
  let aux (n * n + 1 ) / 2
  report aux
end

to-report AI:heuristic [#Goal]
  let pos [[0 0] [0 1] [0 2] [1 0] [1 1] [1 2] [2 0] [2 1] [2 2]]
  let c [content] of current-state
;  One other option is to count the misplaced tiles
  ;  report length filter [ x -> x = False] (map [[x y] -> x = y] c #Goal)
  let filas 0
  let i 0 - 1
  let ene 0 - n
  repeat n [
    set ene ene + n
    set i 0 - 1
    repeat n [
      set i i + 1
      set filas filas + item (i + ene) c]
  ]
  set i 0 - n
  set ene 0 - 1
  let columnas 0
  repeat n [
   set i 0 - 1
   set ene ene + 1
   repeat n [
    set i i + n
    set columnas columnas + item (i + ene) c]
  ]
  set i 0
  let diagonal 0
  repeat n [
    set diagonal diagonal + item i c
    set i i + n + 1
  ]
  let diagonal2 0
  set i n - 1
  repeat n [
  set diagonal2 diagonal2 + item i c
  set i i + n - 1
  ]
  report (filas / n) + (columnas / n) + (diagonal + (diagonal2 / 2)
end


to-report AI:equal? [a b]
  report a = b
end


to test
  ca
  ; From a final position, we randomly move the hole some times
  let In (range 9)
  type 0
  repeat 12 [
    let i position 0 In
    let j one-of movements i
    type (word "->" j)
    set In swap i j In
  ]
  print ""
  print (word "Initial State: " In)
  no-display
  ; We compute the path with A*
  let path (A* In (range 9) True True)
  layout-radial AI:states AI:transitions AI:state 0
  style
  display
  ; if any, we highlight it
  if path != false [
    ;repeat 1000 [layout-spring states links 1 3 .3]
    highlight-path path
    print (word "Actions to sort it: " (map [ s -> first [rule] of s ] path))
  ]
  print (word (max [who] of turtles - count AI:states) " searchers used")
  print (word (count AI:states) " states created")
end

to highlight-path [path]
  foreach path [ s ->
    ask s [
      set color red set thickness .4
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
85
10
522
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
10
10
73
43
NIL
test
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
10
210
72
255
# States
count AI:states
17
1
11

SLIDER
35
510
207
543
n
n
0
100
17.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

circle
false
0
Circle -7500403 true true 0 0 300
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
1.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
