data Context = Home | Mobile | Business
               deriving (Eq, Show)

type Phone = String

albulena = [(Home, "+355-652-55512")]

nils = [(Mobile, "+47-922-55-512"), (Business, "+47-922-12-121"),
        (Home, "+47-925-55-121"), (Business, "+47-922-25-551")]

twalumba = [(Business, "+260-02-55-5121")]

contextIs a (b, _) = a == b

{- abstracting out the pattern via monads -}

class Monad m => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a


instance MonadPlus [] where
    mzero = []
    mplus = (++)


instance MonadPlus Maybe where
    mzero = Nothing
    Nothing `mplus` ys = ys
    xs      `mplus` _  = xs


oneBusinessPhone :: [(Context, Phone)] -> Maybe Phone
oneBusinessPhone ps = lookup Business ps `mplus` lookup Mobile ps

allPersonalPhone :: [(Context, Phone)] -> [Phone]
allPersonalPhone ps = map snd $ filter (contextIs Home) ps `mplus`
                                filter (contextIs Mobile) ps

{- abstracting a puff-up lookup with monad use -}
lookupM :: (MonadPlus m, Eq a) => a -> [(a, b)] -> m b
lookupM _ []     = mzero
lookupM k ((x,y):xys)
  | x == k        = return y `mplus` lookupM k xys
  | otherwise     = lookupM k xys