import arraymancer
import std/[sequtils, strutils, sugar]
import util

let input = block:
  const input = staticRead("day8.txt").strip.splitLines
  input.join.mapIt(parseInt($it)).toTensor.reshape(input.len, input[0].len)

proc visibleFromTop[T](t:Tensor[T]):Tensor[int] =
  let negOne = onesLike[int](t[0, _]).negate.map(x => (x, 0))
  # (S)tore maximum and (A)ccumulate the cells which cause the max to increase.
  func smax_ainc(x:tuple[a, b:int], y:int):type(x) = (max(x.a, y), int(y > x.a))
  t.scanRows(smax_ainc, neg_one).map(x => x.b)

proc visible[T](t:Tensor[T]):Tensor[int] =
  let top = t.visibleFromTop
  let bot = t.flipped.visibleFromTop.flipped
  let lef = t.transpose.visibleFromTop.transpose
  let rig = t.backward.transpose.visibleFromTop.transpose.backward
  (top +. bot +. lef +. rig).clamp(0, 1)

proc treesVisible1d[T](neighbors:Tensor[T], limit:int):int =
  for neighbor in neighbors:
    result.inc
    if neighbor >= limit: break

proc scenicScore[T](t:Tensor[T], tree:seq[int]):int =
  # Trees on the edge score a zero.
  if tree[0] in {0, t.shape[0]-1} or tree[1] in {0, t.shape[1]-1}: return 0
  let height = t[tree[0], tree[1]]
  result  = t[tree[0]+1.._   , tree[1]        ].treesVisible1d(height) # Right
  result *= t[tree[0]-1..0|-1, tree[1]        ].treesVisible1d(height) # Left
  result *= t[tree[0]        , tree[1]+1.._   ].treesVisible1d(height) # Up
  result *= t[tree[0]        , tree[1]-1..0|-1].treesVisible1d(height) # Down

proc main =
  let t = input
  echo("Part1: ", t.visible.sum)
  echo("Part2: ", t.pairs.toSeq.mapIt(t.scenicScore(it[0])).max)

when isMainModule:
  main()
