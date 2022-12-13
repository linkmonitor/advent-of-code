import std/[algorithm, strscans, sequtils, strutils]
import util

type
  Operation = tuple[op:string, value:int] # -1 means use the old value.
  Test = tuple[divby, trueMonkey, falseMonkey:int]
  Monkey = object
    inspected:int
    things :seq[int]
    operation :Operation
    test :Test

func parseMonkey(input:string):Monkey =
  let (_, _, things, op, val, divBy, tmonkey, fmonkey) = input.scanTuple """
Monkey $i:
  Starting items: $+
  Operation: new = old $+ $+
  Test: divisible by $i
    If true: throw to monkey $i
    If false: throw to monkey $i
"""
  result.things = things.split(", ").mapIt(parseInt(it))
  result.operation = (op, if val == "old": -1 else: val.parseInt)
  result.test = (divBy, tmonkey, fmonkey)

const monkeysInit = staticRead("day11.txt").split("\n\n").map(parseMonkey)
const divProd = monkeysInit.mapIt(it.test.divBy).foldl(a*b)

func evaluate(operation:Operation, thing:int, stressReduction:int):int =
  result = if operation.op == "*":
             if operation.value == -1: thing * thing
             else: thing * operation.value
           else: thing + operation.value
  result = (result div stressReduction) mod divProd

func evaluate(test:Test, thing:int):int =
  if thing mod test.divBy == 0: test.trueMonkey else: test.falseMonkey

proc doRound(monkeys:var openarray[Monkey], stressReduction:int=3) =
  for idx, monkey in monkeys:
    for thing in monkey.things:
      let thing = monkey.operation.evaluate(thing, stressReduction)
      let monkey = monkey.test.evaluate(thing)
      monkeys[monkey].things.add(thing)
      monkeys[idx].inspected.inc
    monkeys[idx].things = @[]

func monkeyBusiness(monkeys:openarray[Monkey]):int =
  debugecho(monkeys.mapIt(it.inspected))
  monkeys.mapIt(it.inspected).sorted(Descending)[0..1].foldl(a * b)

proc main =
  var monkeys = monkeysInit
  doTimes 20: monkeys.doRound(stressReduction=3)
  echo("Part1: ", monkeys.monkeyBusiness)

  monkeys = monkeysInit
  doTimes 10_000: monkeys.doRound(stressReduction=1)
  echo("Part2: ", monkeys.monkeyBusiness)


when isMainModule:
  main()
