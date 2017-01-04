import Data.Char

{- # Write a function that takes digits a
 - string then returns the number format # -}
loop :: Int -> String -> Int
loop acc [] = acc
loop acc (x:xs) = loop newAcc xs
                       where newAcc = acc * 10 + digitToInt x

asInt :: String -> Int
asInt xs = loop 0 xs



{- # uppercase # -}
-- 1. uppercase every letter
upperAll :: String -> String
upperAll ""       = ""
upperAll (x:xs)   = (toUpper x) : upperAll xs

-- 2.
upperAll' :: String -> String
upperAll' ""  = ""
upperAll' xs  = map toUpper xs

