import std/[math, sequtils, strutils]

type
  Choice  = enum Rock, Paper, Scissors
  Outcome = enum Lose, Draw, Win
  Round = tuple[a: Choice, b: Choice]

func whatLosesTo(c:Choice):auto = [Rock:Scissors, Paper:Rock, Scissors:Paper][c]
func whatWinsAgainst(c:Choice):auto = whatLosesTo(whatLosesTo(c))

func ToOutcome(round:Round):Outcome =
  if (round.b == whatLosesTo(round.a)): return Lose
  if (round.b == whatWinsAgainst(round.a)): return Win
  if (round.b == round.a): return Draw

func score(outcome:Outcome):int = [Lose:0, Draw:3, Win:6][outcome]
func score(choice:Choice):int = [Rock:1, Paper:2, Scissors:3][choice]
func score(round:Round):int = round.ToOutcome.score + round.b.score

func toChoice(ch:char):Choice =
  if ch in {'A', 'X'}: return Rock
  if ch in {'B', 'Y'}: return Paper
  if ch in {'C', 'Z'}: return Scissors

func alterRound(round:Round):Round =
  case cast[Outcome](round.b): # Entry order in Choice/Outcome permits this.
    of Lose: (round.a, whatLosesTo(round.a))
    of Win:  (round.a, whatWinsAgainst(round.a))
    of Draw: (round.a, round.a)

proc main =
  const input = staticRead("day02.txt").strip()
  let rounds = input.splitLines.mapIt((it[0].toChoice, it[2].toChoice))
  echo("Part1: ", rounds.map(score).sum)
  echo("Part2: ", rounds.mapIt(it.alterRound.score).sum)

when isMainModule:
  main()
