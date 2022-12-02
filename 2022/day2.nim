# Appreciative of your help yesterday, one Elf gives you an encrypted strategy
# guide (your puzzle input) that they say will be sure to help you win. "The
# first column is what your opponent is going to play: A for Rock, B for Paper,
# and C for Scissors. The second column--" Suddenly, the Elf is called away to
# help with someone's tent.
#
# The second column, you reason, must be what you should play in response: X for
# Rock, Y for Paper, and Z for Scissors. Your total score is the sum of your
# scores for each round. The score for a single round is the score for the shape
# you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for
# the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if
# you won).
#
# What would your total score be if everything goes exactly according to your
# strategy guide?
#
# --- Part Two ---
#
# The Elf finishes helping with the tent and sneaks back over to you. "Anyway,
# the second column says how the round needs to end: X means you need to lose, Y
# means you need to end the round in a draw, and Z means you need to win. Good
# luck!"
#
# Following the Elf's instructions for the second column, what would your total
# score be if everything goes exactly according to your strategy guide?

import math
import sequtils
import strutils
import sugar

type
  Choice  = enum Rock, Paper, Scissors
  Outcome = enum Lose, Draw, Win
  Round = tuple[a: Choice, b: Choice]

func LosesTo(choice:Choice):Choice =
  [Rock:Scissors, Paper:Rock, Scissors:Paper][choice]
func WinsAgainst(choice:Choice):Choice =
  [Rock:Paper, Paper:Scissors, Scissors:Rock][choice]

func ToChoice(input:char):Choice =
  if input in ['A','X']: return Rock
  if input in ['B', 'Y']: return Paper
  if input in ['C', 'Z']: return Scissors
  assert(false, "Invalid Input")

func ToOutcome(round:Round):Outcome =
  if round == (round.a, LosesTo(round.a)): Lose
  elif round.a == round.b: Draw
  else: Win

func ScoreRound(round:Round):int =
  [Lose:0, Draw:3, Win:6][ToOutcome(round)] + [Rock:1, Paper:2, Scissors:3][round.b]

func AlterRound(round:Round):Round =
  case cast[Outcome](round.b): # Order of entries Choice/Outcome permit this.
    of Lose: (round.a, LosesTo(round.a))
    of Draw: (round.a, round.a)
    of Win: (round.a, WinsAgainst(round.a))

proc main =
  const input  = staticRead("day2.txt").strip()
  const rounds = input.split('\n').map(x => (ToChoice(x[0]), ToChoice(x[2])))
  echo("Part1: ", rounds.map(ScoreRound).sum)
  echo("Part2: ", rounds.map(x => x.AlterRound.ScoreRound).sum)

when isMainModule:
  main()
