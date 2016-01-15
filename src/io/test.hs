module Test 
  where

import Data.Char

main = do ch <- getChar 
          case ch of
           'a' -> do putChar (toUpper 'a')
           'x' -> return ()

