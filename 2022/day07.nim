import std/[algorithm, critbits, math, os, sequtils, strutils, tables, sugar]
import util

type
  DirTree = CritBitTree[int]
  CommandKind = enum cd, ls
  Command = tuple[kind:CommandKind, dir:string]
  Invocation = tuple[command:Command, output:seq[string]]

template dropEmpty(x:typed):auto = x.filterIt(it.len > 0)

func parseCommand(input:string):Command =
  let terms = input.split(' ')
  if terms.len == 1: return (kind:ls, dir:"") else: (kind:cd, dir:terms[1])

func parseInvocation(input:string):Invocation =
  let lines = input.splitLInes
  result.command = parseCommand(lines[0])
  result.output = lines[1..^1].dropEmpty

func toDirTree(invocations:seq[Invocation]):DirTree =
  var curdir = ""
  for invocation in invocations:
    let (kind, dir) = invocation.command
    case kind:
    of cd:
      if dir.startsWith("/"): curdir = dir
      elif dir == "..": curdir = curdir.parentDir
      else: curdir = curdir / dir
    of ls:
      for entry in invocation.output:
        if entry.startsWith("dir"): continue
        let size = entry.split[0].parseInt
        for path in curdir.parentDirs: result.inc(path, size)

proc main =
  const input = staticRead("day07.txt").strip
  let dirs = input.split("$ ").dropEmpty.map(parseInvocation).toDirTree()
  echo("Part1: ", dirs.values.toSeq.filterIt(it <= 100_000).sum)
  let threshold = 30_000_000 - (70_000_000 - dirs["/"])
  echo("Part2: ", dirs.values.toSeq.sorted.elementFirst(x => x > threshold))

when isMainModule:
  main()
