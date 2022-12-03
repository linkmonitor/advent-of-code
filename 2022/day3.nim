# Each input line describes the contents of a Rucksack. Single letters identify
# Rucksack Items (case sensitive). Rucksacks have two compartments and Items are
# evenly distributed; the first half of the line describes items in the first
# compartment; likewise for the second half of the line and second compartment.
#
# Item identifiers have priorities. a..z have priorities 1..26 and A..Z have
# priorities 27..52. Sum the priorities of items found in both compartments.
#
#--- Part Two ---
#
# Every three input lines represent an elf group. Badges are the only items
# found in all Rucksacks of a group. What is the sum of group-badge priorities?

import itertools
import math
import std/[setutils, sequtils, strutils]

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
  const rucksacks = input.split('\n').map(ParseRuckSack)
  echo("Part1: ", rucksacks.map(Score).sum)
  echo("Part2: ", rucksacks.chunked(3).toSeq.map(Score).sum)

when isMainModule:
  main()
