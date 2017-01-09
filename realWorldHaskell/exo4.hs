
import Data.Char

-- TODO Fix bug "10101" -> 111
-- using foldr
cmpDigit :: Char -> Int -> Int
cmpDigit digit rest = digitToInt digit * 10 ^ (length $ show rest) + rest


asInt_fold :: String -> Int
asInt_fold xs = fromEnum ((foldr cmpDigit 0 xs) `div` 10)