# Part1: Find all task pairs where one range contains the other.
# Part2: Find all task pairs with any overlap whatsoever.

import std/[sequtils, strscans, strutils, sugar]

type
  Task = range[1..99]
  Tasks = set[Task]
  Pair = tuple[a:Tasks, b:Tasks]

func ParseTasks(input:string):Tasks =
  let (_, a, b) = scanTuple(input, "$i-$i")
  {Task(a)..Task(b)}
func ParsePair(input:string):Pair =
  let (_, a, b) = scanTuple(input, "$+,$+")
  (a.ParseTasks, b.ParseTasks)

proc main =
  const input = staticRead("day4.txt").strip()
  let pairs = input.splitLines.map(ParsePair)
  echo("Part1: ", pairs.filter(x => (x.a <= x.b) or (x.b <= x.a)).len)
  echo("Part2: ", pairs.filter(x => (x.a * x.b) != {}).len)

when isMainModule:
  main()
