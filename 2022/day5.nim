import stack
import std/[algorithm, sequtils, strscans, strutils]

type
  Stack = stack.Stack[100, range['A'..'Z']]
  Move  = tuple[num:int, src:int, dst:int]
  State = seq[Stack]

func InitialState(input:string):State =
  let lines = input.split('\n').reversed  # Push bottom of stacks first.
  newSeq(result, parseInt($lines[0][^1])) # Preallocate stacks.
  for line in lines[1..^1]:
    for idx in countup(1, line.high, 4):
      if line[idx] in 'A'..'Z':
        result[(idx+2) div 4].Push(line[idx])

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
