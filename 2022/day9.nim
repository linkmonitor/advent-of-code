import std/[sets, sequtils, strscans, strutils, sugar]

type
  Delta = tuple[a, b:int]
  Position = tuple[a,b:int]
  Context = tuple[head, tail:Position, tails:HashSet[Position]]

func ParseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return (0, dist)
  if dir == "D": return (0, -dist)
  if dir == "L": return (-dist, 0)
  if dir == "R": return (dist, 0)

func ToDelta(a, b:Position):Delta = (a.a - b.a, a.b - b.b)
func Clamp(p:Position, a, b:int):Position = (p.a.clamp(a,b), p.b.clamp(a,b))

proc Apply(position:var Position, delta:Delta) =
  position.a += delta.a
  position.b += delta.b

proc Apply(context:var Context, delta:Delta) =
  let times = abs(delta.a + delta.b)
  let delta = delta.Clamp(-1, 1)
  context.tails.incl(context.tail)
  for _ in 0..<times:
    context.head.Apply(delta)
    let diff = ToDelta(context.head, context.tail)
    if diff.a in [-2, 2] or diff.b in [-2,2]:
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
