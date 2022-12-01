# The Elves take turns writing down the number of Calories contained by the
# various meals, snacks, rations, etc. that they've brought with them, one item
# per line. Each Elf separates their own inventory from the previous Elf's
# inventory (if any) by a blank line.
#
# For example, suppose the Elves finish writing their items' Calories and end up
# with the following list:
#
#--- Part Two ---
#
# By the time you calculate the answer to the Elves' question, they've already
# realized that the Elf carrying the most Calories of food might eventually run
# out of snacks.
#
# To avoid this unacceptable situation, the Elves would instead like to know the
# total Calories carried by the top three Elves carrying the most Calories. That
# way, even if one of those Elves runs out of snacks, they still have two
# backups.
#
# In the example above, the top three Elves are the fourth Elf (with 24000
# Calories), then the third Elf (with 11000 Calories), then the fifth Elf (with
# 10000 Calories). The sum of the Calories carried by these three elves is 45000.
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
    result.add(list.strip().split("\n").map(x => parseInt(x)))

proc main =
  const input = staticRead("day1.txt")
  const calorie_sums = ParseCalorieLists(input).map(x => sum(x))
  echo("Part1: ", calorie_sums.max())
  echo("Part2: ", calorie_sums.sorted(order=Descending)[0..2].sum())

when isMainModule:
  main()
