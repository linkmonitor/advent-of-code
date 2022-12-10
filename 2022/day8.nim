import arraymancer
import std/[sequtils, strutils]
import util

const kInput = staticRead("day8.txt").strip.splitLines
const (kRows, kCols) = (kInput.len, kInput[0].len)
const kNumbers = kInput.join.mapIt(parseInt($it))
let kTensor = kNumbers.toTensor.reshape(kRows, kCols)

proc visibleFromTop[T](t:Tensor[T]):Tensor[int] =
  func umax(x,y:int):int = max(x,y)
  let max_scan = t.ScanRows(umax, zerosLike[T](t[0, _]))
  func ugrt_s(x:tuple[a, b:int], y:int):type(x) = (max(x.a, y), int(y > x.a))
  func augment(x:int):tuple[a,b:int] = (x, 0)
  func extract(x:tuple[a, b:int]):int = x.b
  let neg_one = onesLike[int](t[0,_]).negate
  let increase = max_scan.ScanRows(ugrt_s, neg_one.map(augment))
  increase.map(extract).clamp(0, 1)

proc visible[T](t:Tensor[T]):Tensor[int] =
  let top = t.visibleFromTop
  let bot = t.Flipped.visibleFromTop.Flipped
  let lef = t.transpose.visibleFromTop.transpose
  let rig = t.Reversed.transpose.visibleFromTop.transpose.Reversed
  top +. bot +. lef +. rig

proc main =
  echo("Part1: ", kTensor.visible.clamp(0, 1).sum)

when isMainModule:
  main()
