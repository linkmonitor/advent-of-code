import std/[math, sequtils, strutils]

type
  Instruction = tuple[name:string, value:int]
  Program = seq[Instruction]
  Cpu = tuple[pc:int, x:int]

func parseInstruction(input:string):Instruction =
  if input.startsWith("addx"): ("addx", input.split[1].parseInt)
  else: ("noop", 0)

iterator execute(cpu: var CPU, program: Program):int =
  template tick = cpu.pc.inc; yield cpu.pc
  for instruction in program:
    if instruction.name == "noop": tick
    if instruction.name == "addx": tick; tick; cpu.x += instruction.value

proc signalStrengths(program:Program, limit:int):seq[int] =
  var cpu:Cpu = (pc:0, x:1)
  var sampleAt = 20
  template maybeSample(pc:int) =
    if pc == sampleAt:
      result.add(pc * cpu.x)
      sampleAt += 40
  for pc in cpu.execute(program):
    maybeSample(pc)
  while cpu.pc < limit:
    cpu.pc.inc
    maybeSample(cpu.pc)

proc main =
  const program = staticRead("day10.txt").strip.splitLines.map(parseInstruction)
  echo("Part1: ", program.signalStrengths(220).sum)

when isMainModule:
  main()
