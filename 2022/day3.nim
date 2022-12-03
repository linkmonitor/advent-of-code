# Each line of the input describes the contents of one rucksack. Items are
# identified using single letters (case sensitive). Each rucksack has two
# compartments and items are evenly distributed between them; the first half of
# the line describes items in the first compartment and likewise for the second.
#
# Items have priorities based on their identifiers. Items a..z have priorities
# 1..26 and items A..Z have priorities 27..52. What is the sum of
# bi-compartmental item priorities?
#
#--- Part Two ---
#
# Every three lines represents a group of elves. The only item common to all
# elves in a group is their badge. What is the sum of group badge priorities?

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

func ParseRuckSack(s:string):Rucksack =
  let halves = s.chunked(s.len div 2).toSeq
  (halves[0].toSet, halves[1].toSet)

proc main =
  const input = staticRead("day3.txt").strip()
  const rucksacks = input.split('\n').map(ParseRuckSack)
  echo("Part1: ", rucksacks.map(Score).sum)
  echo("Part2: ", rucksacks.chunked(3).toSeq.map(Score).sum)

when isMainModule:
  main()
