import std/[math, sequtils, strutils]

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

func Score(outcome:Outcome):int = [Lose:0, Draw:3, Win:6][outcome]
func Score(choice:Choice):int = [Rock:1, Paper:2, Scissors:3][choice]
func Score(round:Round):int = round.ToOutcome.Score + round.b.Score

func ToChoice(ch:char):Choice =
  if ch in {'A', 'X'}: return Rock
  if ch in {'B', 'Y'}: return Paper
  if ch in {'C', 'Z'}: return Scissors

func AlterRound(round:Round):Round =
  case cast[Outcome](round.b): # Entry order in Choice/Outcome permits this.
    of Lose: (round.a, WhatLosesTo(round.a))
    of Win:  (round.a, WhatWinsAgainst(round.a))
    of Draw: (round.a, round.a)

proc main =
  const input = staticRead("day2.txt").strip()
  let rounds = input.splitLines.mapIt((it[0].ToChoice, it[2].ToChoice))
  echo("Part1: ", rounds.map(Score).sum)
  echo("Part2: ", rounds.mapIt(it.AlterRound.Score).sum)

when isMainModule:
  main()
