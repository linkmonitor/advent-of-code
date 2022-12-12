import std/[sets, sequtils, strscans, strutils]
import util

type
  Delta    = array[2, int]
  Position = array[2, int]
  Context[N:static int]  = tuple
    knots:array[N, Position]
    tailpos:HashSet[Position]

func parseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return [    0,  dist]
  if dir == "D": return [    0, -dist]
  if dir == "L": return [-dist,     0]
  if dir == "R": return [ dist,     0]

proc chase(tail:var Position, head: Position) =
  let diff = head - tail
  if diff.abs.contains(2): tail += diff.clamp(-1, 1)

proc apply(context:var Context, delta:Delta) =
  context.tailpos.incl(context.knots[^1])
  # Move one space at a time to capture all the tail locations.
  let times = delta.abs.max
  let delta = delta.clamp(-1, 1)
  doTimes times:
    context.knots[0] += delta
    for idx in 1..context.knots.high:
      context.knots[idx].chase(context.knots[idx - 1])
    context.tailpos.incl(context.knots[^1])

proc main =
  const deltas = staticRead("day9.txt").strip.splitLines.map(parseDelta)
  var c2:Context[2]
  for delta in deltas: c2.apply(delta)
  echo("Part1: ", c2.tailpos.len)
  var c10:Context[10]
  for delta in deltas: c10.apply(delta)
  echo("Part2: ", c10.tailpos.len)

when isMainModule:
  main()
