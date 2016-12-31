import Data.Char (digitToInt)

{- only intended for positive numbers -}
toDigits :: Int -> [Int]
toDigits = map digitToInt . show

toDigitsRev :: Int -> [Int]
toDigitsRev = map digitToInt . reverse . show

{- # double every other value from the right # -}
-- 1. pattern matching
doubleP :: [Int] -> [Int]
doubleP [] = []
doubleP (x:[]) = [x]
doubleP (x:y:xs) = x:(y * 2): (doubleP xs)

-- 2. more expressive with zipWith
doubleZ :: [Int] -> [Int]
doubleZ = zipWith (*) (cycle [1, 2])

{- # Another way for doubleZ
 - doubleZ = zipWith ($) (cycle [id, (*2)]) #
 - Found this particular method on StackOverflow -}

{- # very ineficient way # -}
doubleCard :: [Int] -> [Int]
doubleCard = reverse . doubleZ . reverse

sumDigits :: [Int] -> Int
sumDigits = foldl1 (+) . concat . map toDigits

validate :: Int -> Bool
validate n = mod (sumDigits . doubleCard $ toDigits n) 10 == 0


{- links to challenge: https://www.seas.upenn.edu/~cis194/spring13/hw/01-intro.pdf
 - Blogpost about it : https://mohamedhayibor.github.io/blog/post/Credit-Card-Numbers
 -}