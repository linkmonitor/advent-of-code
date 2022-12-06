# The Elves take turns writing down the number of Calories contained by the
# various meals, snacks, rations, etc. that they've brought with them, one item
# per line. Each Elf separates their own inventory from the previous Elf's
# inventory (if any) by a blank line.
#
# Find the Elf carrying the most Calories. How many total Calories is that Elf
# carrying?
#
#--- Part Two ---
#
# Find the top three Elves carrying the most Calories. How many Calories are
# those Elves carrying in total?

import algorithm
import math
import sequtils
import strutils
import sugar

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
