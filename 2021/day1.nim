import itertools
import std/[math, sequtils, strutils, sugar]

func countIncreasing[T](o:openArray[T]):int =
  o.pairwise.toSeq.filter(x => x[0] < x[1]).len

proc main =
  const measurements = staticRead("day1.txt").strip.split('\n').map(parseInt)
  echo("Part1: ", measurements.countIncreasing)
  echo("Part2: ", measurements.windowed(3).toSeq.mapIt(sum(it)).countIncreasing)

when isMainModule:
  main()
