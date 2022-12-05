import stack
import std/[algorithm, sequtils, strscans, strutils]

type
  Crate = range['A'..'Z']
  Stack = stack.Stack[100, Crate]
  Move  = tuple[num:int, src:int, dst:int]
  State = seq[Stack]

func InitialState(input:string):State =
  # Assume two spaces precede each line. Thus, valid crates (or an empty space)
  # appear every four characters.
  let lines = input.split('\n').reversed
  let num_stacks = (2 + lines[0].len) div 4
  newSeq(result, num_stacks)
  for line in lines[1..^1]:
    for idx, ch in line:
      if ((idx + 2) mod 4 == 3) and ch in 'A'..'Z':
        let stack = (idx + 2) div 4
        result[stack].Push(ch)

func ToMove(input:string):Move =
  let (_, num, src, dst) = input.scanTuple("move $i from $i to $i")
  (num, src-1, dst-1)

proc MoveOneByOne(state:var State, move:Move) =
  for _ in 0..<move.num: state[move.dst].Push(state[move.src].Pop())

proc MoveAllAtOnce(state:var State, move:Move) =
  var stack:Stack
  for _ in 0..<move.num: stack.Push(state[move.src].Pop)
  for _ in 0..<move.num: state[move.dst].Push(stack.Pop)

proc main =
  const partitions = staticRead("day5.txt").split("\n\n")
  const moves = partitions[1].split('\n').map(ToMove)
  const initial_state = partitions[0].InitialState

  var state = initial_state
  for move in moves: state.MoveOneByOne(move)
  echo("Part1: ", state.mapIt(it.Top).join())

  state = initial_state
  for move in moves: state.MoveAllAtOnce(move)
  echo("Part2: ", state.mapIt(it.Top).join())

when isMainModule:
  main()
