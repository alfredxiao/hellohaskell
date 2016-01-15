main = do
  putStrLn "Full path of file to read and count:"
  filename <- getLine
  content <- readFile filename
  let size = length content
  putStrLn ("Size:" ++ (show size))
  let lineCount = (length.lines) content
  putStrLn ("Line Count:" ++ (show lineCount))
