
import Data.List
import Data.Function

-- 1. implement length
length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + length' xs


length'' :: [a] -> Int
length'' arr = case arr of
                   []      -> 0
                   (x:xs)  -> 1 + length'' xs


-- 3. implement mean
mean :: [Double] -> Double
mean [] = 0.0
mean xs = (sum xs) / (fromIntegral (length' xs))


-- 4. implement palindrome list
palindrome :: [a] -> [a]
palindrome [] = []
palindrome xs = xs ++ reverse xs


-- 5. Checks for a palindrome case
checkPalindrome :: Eq a => [a] -> Bool
checkPalindrome [] = False
checkPalindrome xs = (xs == (reverse xs))


-- 6. Sort by length of sub List
{- # took me a while to get this
 - on      :: (b -> b -> c) -> (a -> b) -> a -> a -> c
 - compare :: Ord a -> a -> a -> Ordering
 - (compare `on` length) equivalent to (\ x y -> length x compare length y)
 -}
sortByLength :: Foldable t => [t a] -> [t a]
sortByLength xs = sortBy ( compare `on` length) xs


-- 7. join a list of lists together using a separator
intersperse' :: a -> [[a]] -> [a]
intersperse' c = intercalate [c]

-- 8. determine height of a tree
-- TODO: http://book.realworldhaskell.org/read/defining-types-streamlining-functions.html


-- 9. For 3 points a, b, c. Represent right, left, straight with a direction data type TODO




-- 10. calculate the turn made by the third point above TODO




-- 11. compute the direction of each successive triple



-- 12. Implement Graham's scan algorithm for the convex hull set of 2D points


{- # Exos from Chapter 3:
 - http://book.realworldhaskell.org/read/defining-types-streamlining-functions.html
 - 
 -}