{-
 - Hanoi 2 "a" "b" "c" = [("a", "c"), ("a", "b"), ("c", "b")]
-}

-- sleeping on it
type Peg = String
type Move = (Peg, Peg)
hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]