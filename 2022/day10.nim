import itertools
import std/[math, sequtils, strutils]

type
  CpuState = tuple[pc:int, x:int]
  Instruction = tuple[name:string, value:int]
  Program = seq[Instruction]

func parseInstruction(input:string):Instruction =
  if input.startsWith("addx"): ("addx", input.split[1].parseInt)
  else: ("noop", 0)

func execute(initial: CpuState, program: Program, upTo:int):seq[CpuState] =
  var cpuState = initial
  template tick = cpuState.pc.inc; result.add(cpuState)
  for instr in program:
    if instr.name == "noop": tick
    if instr.name == "addx": tick; tick; cpuState.x += instr.value
  while cpuState.pc <= upTo: tick

func signalStrengths(states:seq[CpuState]):seq[int] =
  for (pc, x) in islice(states, 20-1, step=40): result.add(pc * x)

proc main =
  const program = staticRead("day10.txt").strip.splitLines.map(parseInstruction)
  echo("Part1: ", (pc:0, x:1).execute(program, upTo=220).signalStrengths.sum)

when isMainModule:
  main()
