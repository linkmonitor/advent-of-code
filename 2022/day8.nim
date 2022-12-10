import arraymancer
import std/[sequtils, strutils, sugar]

const kInput = staticRead("day8.txt").strip.splitLines
const (kRows, kCols) = (kInput.len, kInput[0].len)
const kNumbers = kInput.join.mapIt(parseInt($it))
let kTensor = kNumbers.toTensor.reshape(kRows, kCols)

proc scan[T, U](arr:openarray[T], start:U, f:(T, U) -> U): seq[U] =
  var last = start
  for elem in arr:
    last = f(last, elem)
    result.add(last)

proc max[T](s1, s2: Tensor[T]):Tensor[T] =
  result = clone(s1)
  doAssert(s1.shape == s2.shape)
  for (idx, item )in result.menumerate:
    item = max(s1.atContiguousIndex(idx),
               s2.atContiguousIndex(idx))

proc increasing[T](s1, s2:Tensor[T]):Tensor[T] =
  result = clone(s1)
  doAssert(s1.shape == s2.shape)
  for (idx, item) in result.menumerate:
    item[0] = s2.atContiguousIndex(idx)[0]
    item[1] = int(s2.atContiguousIndex(idx)[0] >
                  s1.atContiguousIndex(idx)[0])

proc visibleFromLeft[T](t:Tensor[T]):Tensor[int] =
  let shape = t.shape
  let zero_col = zeros[T](shape[0], 1)
  let max_scan = t.split(1, 1).scan(zero_col, max).concat(1)
  let neg1_col = (ones[int](shape[0],1) * -1).map(x => (x, 0))
  let increase = max_scan.map(x => (x, 0)).split(1, 1).scan(neg1_col, increasing).concat(1)
  increase.map(x => int(x[1] > 0))

proc visible[T](t:Tensor[T]):Tensor[int] =
  let left = t.visibleFromLeft
  let right = t[_, ^1..0|-1].visibleFromLeft[_, ^1..0|-1]
  let top = t.transpose.visibleFromLeft.transpose
  let bott = t[^1..0|-1, _].transpose.visibleFromLeft.transpose[^1..0|-1, _]
  left +. right +. top +. bott

proc main =
  echo(kTensor.visible.toSeq.countIt(it > 0))

when isMainModule:
  main()
