import arraymancer
import std/[sequtils, strutils, sugar]
import util

const kInput = staticRead("day8.txt").strip.splitLines
const (kRows, kCols) = (kInput.len, kInput[0].len)
let kTensor = kInput.join.mapIt(parseInt($it)).toTensor.reshape(kRows, kCols)

proc visibleFromTop[T](t:Tensor[T]):Tensor[int] =
  let neg_one = onesLike[int](t[0, _]).negate.map(x => (x, 0))
  # (S)tore maximum and (A)ccumulate the cells which cause the max to increase.
  func smax_ainc(x:tuple[a, b:int], y:int):type(x) = (max(x.a, y), int(y > x.a))
  t.ScanRows(smax_ainc, neg_one).map(x => x.b)

proc visible[T](t:Tensor[T]):Tensor[int] =
  let top = t.visibleFromTop
  let bot = t.Flipped.visibleFromTop.Flipped
  let lef = t.transpose.visibleFromTop.transpose
  let rig = t.Reversed.transpose.visibleFromTop.transpose.Reversed
  (top +. bot +. lef +. rig).clamp(0, 1)

proc main =
  echo("Part1: ", kTensor.visible.sum)

when isMainModule:
  main()
