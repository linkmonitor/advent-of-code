import std/[strutils]

const kNumbers = staticRead("day3.txt").strip.splitLines
const kLineLen = kNumbers[0].len

type
  Context = object
    counters: array[kLineLen, int]
    numProcessed: int

proc ProcessNumber(context:var Context, number:string) =
  for idx, ch in number:
    if ch == '1': context.counters[idx].inc
  context.numProcessed.inc

func ToGammaRate(context:Context):int =
  for counter in context.counters:
    result = result.shl(1)
    if counter > (context.numProcessed div 2):
      result = result or 1

func ToEpsilonRate(context:Context):int =
  for counter in context.counters:
    result = result.shl(1)
    if counter < (context.numProcessed div 2):
      result = result or 1

# TODO(jjaoudi): Continue by calculating the oxygen generator rating.

proc main =
  var context:Context
  for number in kNumbers: ProcessNumber(context, number)
  echo("Part1: ", context.ToEpsilonRate * context.ToGammaRate)

when isMainModule:
  main()
