import itertools
import std/[math, setutils, sequtils, strutils]

type
  Item = char
  Items = set[Item]
  Rucksack = tuple[a:Items, b:Items]
  Group = seq[Rucksack]

func commonItems(rucksack:Rucksack):Items = rucksack.a * rucksack.b
func commonItems(group:Group):Items = group.mapIt(it.a + it.b).foldl(a * b)

func score(item:Item):int =
  if item in 'a'..'z': return ord(item) - ord('a') + 1
  if item in 'A'..'Z': return ord(item) - ord('A') + 27
func score(rucksack:Rucksack):int = rucksack.commonItems.toSeq.map(score).sum
func score(group:Group):int = group.commonItems.toSeq.map(score).sum

func mid(s:string):int = s.len div 2
func parseRucksack(s:string):Rucksack = (s[0..<s.mid].toSet, s[s.mid..^1].toSet)

proc main =
  const input = staticRead("day3.txt").strip()
  const rucksacks = input.splitLines.map(parseRucksack)
  echo("Part1: ", rucksacks.map(score).sum)
  echo("Part2: ", rucksacks.chunked(3).toSeq.map(score).sum)

when isMainModule:
  main()
