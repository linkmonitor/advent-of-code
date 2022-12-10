import arraymancer
import std/[sequtils, strutils, sugar]
import util

const kInput = staticRead("day8.txt").strip.splitLines
let kTensor = block:
  const (kRows, kCols) = (kInput.len, kInput[0].len)
  kInput.join.mapIt(parseInt($it)).toTensor.reshape(kRows, kCols)

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

proc scenicScore[T](t:Tensor[T], tree:tuple[a,b:int]):int =
  let (kRows, kCols) = (t.shape[0], t.shape[1])
  let height = t[tree.a, tree.b]
  result = 1
  var scores:seq[int]
  var trees = 0
  for col in (tree.b+1)..<kCols:
    trees.inc
    if t[tree.a, col] >= height: break
  scores.add(trees)
  result *= trees
  trees = 0
  for col in countdown(tree.b-1, 0):
    trees.inc
    if t[tree.a, col] >= height: break
  scores.add(trees)
  result *= trees
  trees = 0
  for row in (tree.a+1)..<kRows:
    trees.inc
    if t[row, tree.b] >= height: break
  scores.add(trees)
  result *= trees
  trees = 0
  for row in countdown(tree.a-1, 0):
    trees.inc
    if t[row, tree.b] >= height: break
  scores.add(trees)
  result *= trees

proc highestScenicScore[T](t:Tensor[T]):int =
  for (coord, _) in t.pairs:
    let tree = (coord[0], coord[1])
    let score = t.scenicScore(tree)
    result = max(result, score)

proc main =
  echo("Part1: ", kTensor.visible.sum)
  echo("Part2: ", kTensor.highestScenicScore)

when isMainModule:
  main()
