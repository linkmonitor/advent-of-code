type
  Stack*[N:static[int], T] = object
    data:array[N, T]
    index:int

proc clear*[N,T](stack:var Stack[N,T]) =
  stack.index = 0

proc push*[N,T](stack:var Stack[N,T], element:T) =
  if stack.index >= N: raise new OverFlowDefect
  stack.data[stack.index] = element
  stack.index.inc

proc pop*[N,T](stack:var Stack[N,T]):T =
  if stack.index == 0: raise new OutOfMemDefect
  stack.index.dec
  stack.data[stack.index]

proc top*[N,T](stack:Stack[N,T]):T =
  if stack.index == 0: raise new OutOfMemDefect
  stack.data[stack.index - 1]

proc len*[N,T](stack:Stack[N,T]):int =
  stack.index
