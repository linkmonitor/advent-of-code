import std/[sets, sequtils, strscans, strutils]
import util

type
  Delta    = array[2, int]
  Position = array[2, int]
  Context[N:static int]  = tuple
    knots:array[N, Position]
    tailpos:HashSet[Position]

func ParseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return [    0,  dist]
  if dir == "D": return [    0, -dist]
  if dir == "L": return [-dist,     0]
  if dir == "R": return [ dist,     0]

proc Chase(tail:var Position, head: Position) =
  let diff = head - tail
  if diff.Abs.contains(2): tail += diff.Clamp(-1, 1)

proc Apply(context:var Context, delta:Delta) =
  context.tailpos.incl(context.knots[^1])
  # Move one space at a time to capture all the tail locations.
  let times = delta.Abs.max
  let delta = delta.Clamp(-1, 1)
  doTimes times:
    context.knots[0] += delta
    for idx in 1..context.knots.high:
      context.knots[idx].Chase(context.knots[idx - 1])
    context.tailpos.incl(context.knots[^1])

proc main =
  const deltas = staticRead("day9.txt").strip.splitLines.map(ParseDelta)
  var c2:Context[2]
  for delta in deltas: c2.Apply(delta)
  echo("Part1: ", c2.tailpos.len)
  var c10:Context[10]
  for delta in deltas: c10.Apply(delta)
  echo("Part2: ", c10.tailpos.len)

when isMainModule:
  main()
