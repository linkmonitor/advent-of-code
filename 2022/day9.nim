import std/[sets, sequtils, strscans, strutils]
import util

type
  Delta    = array[2, int]
  Position = array[2, int]
  Context  = tuple[head, tail:Position, tailpos:HashSet[Position]]

func ParseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return [    0,  dist]
  if dir == "D": return [    0, -dist]
  if dir == "L": return [-dist,     0]
  if dir == "R": return [ dist,     0]

proc Chase(tail:var Position, head: Position) =
  let diff = head - tail
  if 2 in diff.Abs: tail += diff.Clamp(-1, 1)

proc Apply(context:var Context, delta:Delta) =
  context.tailpos.incl(context.tail)
  # Move one space at a time to capture all the tail locations.
  let times = delta.Abs.max
  let delta = delta.Clamp(-1, 1)
  doTimes times:
    context.head += delta
    context.tail.Chase(context.head)
    context.tailpos.incl(context.tail)

proc main =
  const deltas = staticRead("day9.txt").strip.splitLines.map(ParseDelta)
  var context:Context
  for delta in deltas: context.Apply(delta)
  echo("Part1: ", context.tailpos.len)

when isMainModule:
  main()
