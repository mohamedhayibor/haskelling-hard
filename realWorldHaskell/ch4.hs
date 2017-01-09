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



-- filter with pattern matching
filter' :: (a -> Bool) -> [a] -> [a]
filter' f [] = []
filter' f (x:xs) | f x       = x: filter' f xs
                 | otherwise = filter' f xs


-- filter with fold
filterW :: (a -> Bool) -> [a] -> [a]
filterW f xs = foldr step [] xs
               where step x ys | f x       = x:ys
                               | otherwise = ys


-- map with foldr
myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f xs = foldr step [] xs
             where step y ys = f y :ys


-- foldl with foldr (mind bending!!!)
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f base [] = base
myFoldl f base xs = foldr step id xs base
                    where step id xs base = xs (f base id)


