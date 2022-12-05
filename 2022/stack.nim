type
  Stack*[N:static[int], T] = object
    data:array[N, T]
    index:int

proc Clear*[N,T](stack:var Stack[N,T]) =
  stack.index = 0

proc Push*[N,T](stack:var Stack[N,T], element:T) =
  if stack.index >= N: raise new OverFlowDefect
  stack.data[stack.index] = element
  stack.index.inc

proc Pop*[N,T](stack:var Stack[N,T]):T =
  if stack.index == 0: raise new OutOfMemDefect
  stack.index.dec
  stack.data[stack.index]

proc Top*[N,T](stack:Stack[N,T]):T =
  if stack.index == 0: raise new OutOfMemDefect
  stack.data[stack.index - 1]

proc len*[N,T](stack:Stack[N,T]):int =
  stack.index
