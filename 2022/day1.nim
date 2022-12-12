import std/[algorithm, math, sequtils, strutils, sugar]

type
  Calorie = int
  CalorieList = seq[Calorie]

func parseCalorieLists(input:string):seq[CalorieList] =
  for list in input.split("\n\n"):
    result.add(list.strip().splitLines.map(x => parseInt(x)))

proc main =
  const input = staticRead("day1.txt")
  const calorieSums = parseCalorieLists(input).map(x => sum(x))
  echo("Part1: ", calorieSums.max())
  echo("Part2: ", calorieSums.sorted(order=Descending)[0..2].sum())

when isMainModule:
  main()
