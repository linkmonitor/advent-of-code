import arraymancer
import arraymancer/laser/strided_iteration/foreach
import std/[sugar]

template doTimes*(n:Natural, body:typed) =
  for _ in 0..<n:
    body

proc indexFirst*[T](arr:openArray[T], pred:proc(x:T):bool):int =
  for index, element in arr:
    if pred(element): return index
  return -1

proc elementFirst*[T](arr:openArray[T], pred:proc(x:T):bool):T =
  arr[arr.indexFirst(pred)]

template universal[T, U, V](f:(T, U) -> V):auto =
  proc(a:Tensor[T], b:Tensor[U]):Tensor[V] =
    doAssert(a.shape == b.shape)
    result = clone(a)
    forEach x in a, y in b, z in result: z = f(x, y)

proc scan*[T, U](xs:openarray[T], x0:U, f:(U, T) -> U): seq[U] =
  var xn_1 = x0
  for x in xs:
    xn_1 = f(xn_1, x)
    result.add(xn_1)

proc scanRows*[T, U](t:Tensor[T], f:proc(x:U,y:T):U, t0:Tensor[U]): Tensor[U] =
  const uf = universal(f)
  t.split(1,0).scan(t0, uf).concat(0)
proc scanRows*[T, U](t:Tensor[T], f:proc(x:U,y:T):U): Tensor[U] =
  t[1.._, _].scanRows(f, t[0,_])
proc scanCols*[T, U](t:Tensor[T], f:proc(x:U,y:T):U): Tensor[U] =
  t.transpose.scanRows(f).transpose
proc scanCols*[T, U](t:Tensor[T], f:proc(x:U,y:T):U, t0:Tensor[U]): Tensor[U] =
  t.transpose.scanRows(f, t0.transpose).transpose

proc flipped*[T](t:Tensor[T]):Tensor[T] = t[^1..0|-1, _]
proc backward*[T](t:Tensor[T]):Tensor[T] = t[_, ^1..0|-1]

func `-`*[M, T](a, b:array[M, T]):array[M, T] =
  for idx, value in result.mpairs: value = a[idx] - b[idx]
func `+`*[M, T](a, b:array[M, T]):array[M, T] =
  for idx, value in result.mpairs: value = a[idx] + b[idx]
func clamp*[M, T](a:array[M,T], n, m:int):array[M, T] =
  for idx, value in result.mpairs: value = a[idx].clamp(n, m)
func abs*[M, T](a:array[M,T]):array[M, T] =
  for idx, value in result.mpairs: value = abs(a[idx])
proc `+=`*[M, T](a:var array[M, T], b:array[M, T]) =
  for idx, value in a.mpairs: value += b[idx]


