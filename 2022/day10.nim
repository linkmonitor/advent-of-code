import itertools
import std/[math, sequtils, strutils, sugar]

type
  CpuState = tuple[pc:int, x:int]
  Instruction = tuple[name:string, value:int]
  Program = seq[Instruction]
  Screen = array[6, array[40, bool]]

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

func `$`(screen:Screen):string =
  screen.mapIt(it.map(p => ['-', '#'][int(p)]).join).join("\n")

func render(states:seq[CpuState]):Screen =
  for (pc, x) in states:
    let row = (pc - 1) div 40
    let col = (pc - 1) mod 40
    if col in [x-1, x, x+1]: result[row][col] = true

proc main =
  const program = staticRead("day10.txt").strip.splitLines.map(parseInstruction)
  echo("Part1: ",  (pc:0, x:1).execute(program, upTo=220).signalStrengths.sum)
  echo("Part2:\n", (pc:0, x:1).execute(program, upTo=220).render)

when isMainModule:
  main()
