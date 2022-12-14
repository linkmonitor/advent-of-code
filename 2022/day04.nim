import std/[sequtils, strscans, strutils, sugar]

type
  Task = range[1..99]
  Tasks = set[Task]
  Pair = tuple[a:Tasks, b:Tasks]

func parseTasks(input:string):Tasks =
  let (_, a, b) = scanTuple(input, "$i-$i")
  {Task(a)..Task(b)}
func parsePair(input:string):Pair =
  let (_, a, b) = scanTuple(input, "$+,$+")
  (a.parseTasks, b.parseTasks)

proc main =
  const input = staticRead("day04.txt").strip()
  let pairs = input.splitLines.map(parsePair)
  echo("Part1: ", pairs.filter(x => (x.a <= x.b) or (x.b <= x.a)).len)
  echo("Part2: ", pairs.filter(x => (x.a * x.b) != {}).len)

when isMainModule:
  main()
