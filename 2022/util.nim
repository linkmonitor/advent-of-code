import arraymancer
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
  const u = proc(a:Tensor[T], b:Tensor[U]):Tensor[V] =
    doAssert(a.shape == b.shape)
    result = clone(a)
    for (idx, elt) in result.menumerate:
      elt = f(a.atContiguousIndex(idx), b.atContiguousIndex(idx))
  u

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
