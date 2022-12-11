import std/[sets, sequtils, strscans, strutils]
import util

type
  Delta    = array[2, int]
  Position = array[2, int]
  Context  = tuple[head, tail:Position, tails:HashSet[Position]]

func ParseDelta(input:string):Delta =
  let (_, dir, dist) = input.scanTuple("$+ $i")
  if dir == "U": return [    0,  dist]
  if dir == "D": return [    0, -dist]
  if dir == "L": return [-dist,     0]
  if dir == "R": return [ dist,     0]

proc Apply(context:var Context, delta:Delta) =
  let times = delta.Abs.max
  let delta = delta.Clamp(-1, 1)
  context.tails.incl(context.tail)
  for _ in 0..<times:
    context.head += delta
    let diff = context.head - context.tail
    if 2 in diff.Abs:
      context.tail += diff.Clamp(-1, 1)
      context.tails.incl(context.tail)

proc main =
  const deltas = staticRead("day9.txt").strip.splitLines.map(ParseDelta)
  var context:Context
  for delta in deltas: context.Apply(delta)
  echo("Part1: ", context.tails.len)

when isMainModule:
  main()
