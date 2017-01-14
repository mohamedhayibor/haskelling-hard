import Test.QuickCheck
import Data.List

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort bigger
            where smaller = [a | a <- xs, a < x]
                  bigger  = [a | a <- xs, a >= x]

prop_idempotent :: [Integer] -> Bool
prop_idempotent xs = qsort (qsort xs) == qsort xs


{- excluding [] : empty arrays -}
prop_minimum :: Ord a => [a] -> Property
prop_minimum xs = not (null xs) ==> head (qsort xs) == minimum xs


{- testing properties -}
prop_ordered xs = ordered (qsort xs)
    where ordered []         = True
          ordered [x]        = True
          ordered (x:y:xs)   = x <= y && ordered (y:xs)


prop_permutation xs = permutation xs (qsort xs)
    where permutation xs ys = null (xs \\ ys) && null (ys \\ xs)


prop_maximum xs = not (null xs) ==> last (qsort xs) == maximum xs


prop_append xs ys =
    not (null xs) ==>
    not (null ys) ==>
        head (qsort (xs ++ ys)) == min (minimum xs) (minimum ys)


{- Testing against a model -}
prop_sort_model xs = sort xs == qsort xs