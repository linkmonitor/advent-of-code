template doTimes*(n:Natural, body:typed) =
  for _ in 0..<n:
    body

proc IndexFirst*[T](arr:openArray[T], pred:proc(x:T):bool):int =
  for index, element in arr:
    if pred(element): return index
  return -1

proc ElementFirst*[T](arr:openArray[T], pred:proc(x:T):bool):T =
  arr[arr.IndexFirst(pred)]
