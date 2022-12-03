# The input is a strategy guide for several Rounds of rock, paper, scissors. It
# has two, space-delimited columns. The first column represents your opponents
# Choice in that round: A for Rock, B for Paper, and C for Scissors. The second
# column represents what you should Choose for that round: X for Rock, Y for
# Paper, and Z for scissors.
#
# Each round's score is the sum of the outcome and choice scores. Winning,
# Drawing, and Losing award 6, 3, and 0 points respectively for the outcome.
# Rock, Paper, and Scissors award 1, 2, 3 points respectively for your choice.
#
# What is your total score?
#
# --- Part Two ---
#
# Reinterpret the second column of the input-now X means lose, Y means draw and
# Z means win-play again, and score rounds the same way.
#
# What is your total score?

import math
import sequtils
import strutils

type
  Choice  = enum Rock, Paper, Scissors
  Outcome = enum Lose, Draw, Win
  Round = tuple[a: Choice, b: Choice]

func WhatLosesTo(c:Choice):auto = [Rock:Scissors, Paper:Rock, Scissors:Paper][c]
func WhatWinsAgainst(c:Choice):auto = WhatLosesTo(WhatLosesTo(c))

func ToOutcome(round:Round):Outcome =
  if (round.b == WhatLosesTo(round.a)): return Lose
  if (round.b == WhatWinsAgainst(round.a)): return Win
  if (round.b == round.a): return Draw

func ToPoints(outcome:Outcome):int = [Lose:0, Draw:3, Win:6][outcome]
func ToPoints(choice:Choice):int = [Rock:1, Paper:2, Scissors:3][choice]
func ToPoints(round:Round):int = round.ToOutcome.ToPoints + round.b.ToPoints

func ToChoice(input:char):Choice =
  if input in {'A', 'X'}: return Rock
  if input in {'B', 'Y'}: return Paper
  if input in {'C', 'Z'}: return Scissors

func AlterRound(round:Round):Round =
  case cast[Outcome](round.b): # Entry order in Choice/Outcome permits this.
    of Lose: (round.a, WhatLosesTo(round.a))
    of Win:  (round.a, WhatWinsAgainst(round.a))
    of Draw: (round.a, round.a)

proc main =
  const input = staticRead("day2.txt").strip()
  let rounds = input.split('\n').mapIt((ToChoice(it[0]), ToChoice(it[2])))
  echo("Part1: ", rounds.map(ToPoints).sum)
  echo("Part2: ", rounds.mapIt(it.AlterRound.ToPoints).sum)

when isMainModule:
  main()
