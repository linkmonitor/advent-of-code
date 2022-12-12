import stack, util
import std/[algorithm, sequtils, strscans, strutils]

type
  Stack = stack.Stack[100, range['A'..'Z']]
  Move  = tuple[num:int, src:int, dst:int]
  State = seq[Stack]

func initialState(lines:seq[string]):State =
  newSeq(result, parseInt($lines[0][^1])) # Preallocate stacks.
  for line in lines[1..^1]:
    for idx in countup(1, line.high, 4):
      if line[idx] in 'A'..'Z':
        result[(idx+2) div 4].push(line[idx])

func toMove(input:string):Move =
  let (_, num, src, dst) = input.scanTuple("move $i from $i to $i")
  (num, src-1, dst-1)

proc moveOneByOne(state:var State, move:Move) =
  doTimes(move.num): state[move.dst].push(state[move.src].pop)

proc moveAllAtOnce(state:var State, move:Move) =
  var stack:Stack
  doTimes(move.num): stack.push(state[move.src].pop)
  doTimes(move.num): state[move.dst].push(stack.pop)

proc main =
  const partitions = staticRead("day05.txt").split("\n\n")
  const moves = partitions[1].splitLines.map(toMove)
  const initialState = partitions[0].splitLines.reversed.initialState

  var state = initialState
  for move in moves: state.moveOneByOne(move)
  echo("Part1: ", state.mapIt(it.top).join())

  state = initialState
  for move in moves: state.moveAllAtOnce(move)
  echo("Part2: ", state.mapIt(it.top).join())

when isMainModule:
  main()
