import arraymancer
import arraymancer/laser/strided_iteration/foreach
import std/[sugar]

template doTimes*(n:Natural, body:typed) =
  for _ in 0..<n:
    body

proc IndexFirst*[T](arr:openArray[T], pred:proc(x:T):bool):int =
  for index, element in arr:
    if pred(element): return index
  return -1

proc ElementFirst*[T](arr:openArray[T], pred:proc(x:T):bool):T =
  arr[arr.IndexFirst(pred)]

template universal[T, U, V](f:(T, U) -> V):auto =
  proc(a:Tensor[T], b:Tensor[U]):Tensor[V] =
    doAssert(a.shape == b.shape)
    result = clone(a)
    forEach x in a, y in b, z in result: z = f(x, y)

proc Scan*[T, U](xs:openarray[T], x0:U, f:(U, T) -> U): seq[U] =
  var xn_1 = x0
  for x in xs:
    xn_1 = f(xn_1, x)
    result.add(xn_1)

proc ScanRows*[T, U](t:Tensor[T], f:proc(x:U,y:T):U, t0:Tensor[U]): Tensor[U] =
  const uf = universal(f)
  t.split(1,0).Scan(t0, uf).concat(0)
proc ScanRows*[T, U](t:Tensor[T], f:proc(x:U,y:T):U): Tensor[U] =
  t[1.._, _].ScanRows(f, t[0,_])
proc ScanCols*[T, U](t:Tensor[T], f:proc(x:U,y:T):U): Tensor[U] =
  t.transpose.ScanRows(f).transpose
proc ScanCols*[T, U](t:Tensor[T], f:proc(x:U,y:T):U, t0:Tensor[U]): Tensor[U] =
  t.transpose.ScanRows(f, t0.transpose).transpose

proc Flipped*[T](t:Tensor[T]):Tensor[T] = t[^1..0|-1, _]
proc Reversed*[T](t:Tensor[T]):Tensor[T] = t[_, ^1..0|-1]

func `-`*[M, T](a, b:array[M, T]):array[M, T] =
  for idx, value in result.mpairs: value = a[idx] - b[idx]
func `+`*[M, T](a, b:array[M, T]):array[M, T] =
  for idx, value in result.mpairs: value = a[idx] + b[idx]
func Clamp*[M, T](a:array[M,T], n, m:int):array[M, T] =
  for idx, value in result.mpairs: value = a[idx].clamp(n, m)
func Abs*[M, T](a:array[M,T]):array[M, T] =
  for idx, value in result.mpairs: value = abs(a[idx])
proc  `+=`*[M, T](a:var array[M, T], b:array[M, T]) =
  for idx, value in a.mpairs: value += b[idx]


