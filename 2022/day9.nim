import std/[sets, sequtils, strscans, strutils, sugar]

type
  Delta    = array[2, int]
  Position = array[2, int]
  Context  = tuple[head, tail:Position, tails:HashSet[Position]]

func ParseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return [0, dist]
  if dir == "D": return [0, -dist]
  if dir == "L": return [-dist, 0]
  if dir == "R": return [dist, 0]

func ToDelta(a, b:Position):Delta = [a[0] - b[0], a[1] - b[1]]
func Clamp(p:Position, a, b:int):Position = [p[0].clamp(a,b), p[1].clamp(a,b)]

proc Apply(position:var Position, delta:Delta) =
  position[0] += delta[0]
  position[1] += delta[1]

proc Apply(context:var Context, delta:Delta) =
  let times = abs(delta[0] + delta[1])
  let delta = delta.Clamp(-1, 1)
  context.tails.incl(context.tail)
  for _ in 0..<times:
    context.head.Apply(delta)
    let diff = ToDelta(context.head, context.tail)
    if diff[0] in [-2, 2] or diff[1] in [-2,2]:
      let diff = diff.Clamp(-1, 1)
      context.tail.Apply(diff)
      context.tails.incl(context.tail)

const deltas = staticRead("day9.txt").strip.splitLines.map(ParseDelta)

proc main =
  var context:Context
  for delta in deltas: context.Apply(delta)
  echo("Part1: ", context.tails.len)

when isMainModule:
  main()
