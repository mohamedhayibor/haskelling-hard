
{- prettyfy a math calc
 - prettyShow (5 * 4 - 4) = "(5*4)-4"
 - -}

data SymbolicManip a =
    Number a
  | Symbol String          -- A symbol, such as x
  | BinaryArith Op (SymbolicManip a) (SymbolicManip a)
  | UnaryArith String (SymbolicManip a)
    deriving (Eq)


data Op = Plus | Minus | Mul | Div | Pow deriving (Eq, Show)


instance Num a => Num (SymbolicManip a) where
    a + b = BinaryArith Plus a b
    a - b = BinaryArith Minus a b
    a * b = BinaryArith Mul a b
    abs a = error "abs is not impl."
    signum _ = error "not impl."
    fromInteger i = Number (fromInteger i)

prettyShow :: (Show a, Num a) => SymbolicManip a -> String
-- show a number or symbol as a bare number or serial
prettyShow (Number x) = show x
prettyShow (Symbol x) = x


prettyShow (BinaryArith op a b) = pa ++ pop ++ pb
    where pa = simpleParen a
          pb = simpleParen b
          pop = op2str op
prettyShow (UnaryArith opstr a) =
    opstr ++ "(" ++ show a ++ ")"


op2str :: Op -> String
op2str Plus = "+"
op2str Minus = "-"
op2str Mul = "*"
op2str Div = "/"
op2str Pow = "**"


simpleParen :: (Show a, Num a) => SymbolicManip a -> String
simpleParen (Number x) = prettyShow (Number x)
simpleParen (Symbol x) = prettyShow (Symbol x)
simpleParen x@(BinaryArith _ _ _) = "(" ++ prettyShow x ++ ")"
simpleParen x@(UnaryArith _ _) = prettyShow x

{- Showing a SymbolicManip calls the prettyShow function on it -}
instance (Show a, Num a) => Show (SymbolicManip a) where
    show a = prettyShow a