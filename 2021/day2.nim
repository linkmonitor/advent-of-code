import std/[sequtils, strscans, strutils]

type
  Direction = enum up, down, forward
  Command   = tuple[d:Direction, n:int]
  Position  = tuple[x, y, aim:int]

func ToCommand(input:string):Command =
  let (_, command, n) = input.scanTuple("$+ $i")
  (parseEnum[Direction](command), n)

proc Apply(pos:var Position, cmd:Command) =
  case cmd.d
  of up: pos.y.dec(cmd.n)
  of down: pos.y.inc(cmd.n)
  of forward: pos.x.inc(cmd.n)

proc ApplyWithAim(pos:var Position, cmd:Command) =
  case cmd.d
  of up: pos.aim.dec(cmd.n)
  of down: pos.aim.inc(cmd.n)
  of forward: pos.x.inc(cmd.n); pos.y.inc(pos.aim * cmd.n)

proc main =
  const input = staticRead("day2.txt").strip()
  const commands = input.splitLines.map(ToCommand)

  var position:Position = (0, 0, 0)
  for command in commands: position.Apply(command)
  echo("Part1: ", position.x * position.y)

  position = (0, 0, 0)
  for command in commands: position.ApplyWithAim(command)
  echo("Part2: ", position.x * position.y)

when isMainModule:
  main()
