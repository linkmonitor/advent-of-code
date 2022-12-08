import std/[algorithm, math, sequtils, strutils, sugar]

type
  Calorie = int
  CalorieList = seq[Calorie]

func ParseCalorieLists(input:string):seq[CalorieList] =
  for list in input.split("\n\n"):
    result.add(list.strip().splitLines.map(x => parseInt(x)))

proc main =
  const input = staticRead("day1.txt")
  const calorie_sums = ParseCalorieLists(input).map(x => sum(x))
  echo("Part1: ", calorie_sums.max())
  echo("Part2: ", calorie_sums.sorted(order=Descending)[0..2].sum())

when isMainModule:
  main()
