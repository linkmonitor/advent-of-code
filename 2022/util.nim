template doTimes*(n:Natural, body:typed) =
  for _ in 0..<n:
    body
