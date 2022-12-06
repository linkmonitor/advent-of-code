import itertools, util
import std/[sequtils, setutils, strutils, sugar]

func CharsAreUnique(array:seq[char]):bool = array.toSet.len == array.len

proc main =
  const input = staticRead("day6.txt").strip()
  echo("Part1: ", input.windowed(4).toSeq.IndexFirst(CharsAreUnique) + 4)
  echo("Part2: ", input.windowed(14).toSeq.IndexFirst(CharsAreUnique) + 14)

when isMainModule:
  main()
