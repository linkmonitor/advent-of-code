import std/[sequtils, strutils]

const test_input = """
30373
25512
65332
33549
35390
""".strip.splitLines

type
  Tree = tuple[a,b:int]
  Height = int
  Direction = enum North, East, South, West

const kInput = test_input #staticRead("day8.txt").strip.splitLines
const (kRows, kCols) = (kInput.len, test_input[0].len)
const kForest = block:
    var forest:array[kRows, array[kCols, int]]
    for row, line in kInput:
      for col, ch in line:
        forest[row][col] = parseInt($ch)
    forest
const kTrees = block:
    var trees:seq[Tree]
    for a in 0..<kRows:
      for b in 0..<kCols:
        trees.add((a, b))
    trees

iterator Neighbors(tree:Tree, direction:Direction):Height =
  case direction:
    of North: (for i in 0..<tree.a:         yield kForest[i][tree.b])
    of South: (for i in (tree.a+1)..<kRows: yield kForest[i][tree.b])
    of West:  (for i in 0..<tree.b:         yield kForest[tree.a][i])
    of East:  (for i in (tree.b+1)..<kCols: yield kForest[tree.a][i])

proc IsVisible(tree:Tree):bool =
  let value = kForest[tree.a][tree.b]
  for direction in Direction:
    if tree.Neighbors(direction).toseq.allIt(it < value): return true

proc main =
  echo("Part1: ", kTrees.filter(IsVisible).len)


when isMainModule:
  main()
