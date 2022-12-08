import itertools
import std/[math, setutils, sequtils, strutils]

type
  Item = char
  Items = set[Item]
  Rucksack = tuple[a:Items, b:Items]
  Group = seq[Rucksack]

func CommonItems(rucksack:Rucksack):Items = rucksack.a * rucksack.b
func CommonItems(group:Group):Items = group.mapIt(it.a + it.b).foldl(a * b)

func Score(item:Item):int =
  if item in 'a'..'z': return ord(item) - ord('a') + 1
  if item in 'A'..'Z': return ord(item) - ord('A') + 27
func Score(rucksack:Rucksack):int = rucksack.CommonItems.toSeq.map(Score).sum
func Score(group:Group):int = group.CommonItems.toSeq.map(Score).sum

func Mid(s:string):int = s.len div 2
func ParseRuckSack(s:string):Rucksack = (s[0..<s.Mid].toSet, s[s.Mid..^1].toSet)

proc main =
  const input = staticRead("day3.txt").strip()
  const rucksacks = input.splitLines.map(ParseRuckSack)
  echo("Part1: ", rucksacks.map(Score).sum)
  echo("Part2: ", rucksacks.chunked(3).toSeq.map(Score).sum)

when isMainModule:
  main()
