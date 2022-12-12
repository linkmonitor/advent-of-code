import itertools, util
import std/[sequtils, setutils, strutils]

func charsAreUnique(array:seq[char]):bool = array.toSet.len == array.len

proc main =
  const input = staticRead("day6.txt").strip()
  echo("Part1: ", input.windowed(4).toSeq.indexFirst(charsAreUnique) + 4)
  echo("Part2: ", input.windowed(14).toSeq.indexFirst(charsAreUnique) + 14)

when isMainModule:
  main()
