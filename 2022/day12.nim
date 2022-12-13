import std/[strutils]

const input = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
""".strip.splitLines

proc main =
  echo(input)

when isMainModule:
  main()
