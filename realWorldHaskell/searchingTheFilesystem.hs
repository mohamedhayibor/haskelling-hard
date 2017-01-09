import System.FilePath
import System.IO
import System.Environment


{- # checking for a haskell source file over 128kb # -}
myTest :: (Ord a, Num a) => FilePath -> t -> Maybe a -> t1 -> Bool
myTest path _ (Just size) _ =
    takeExtension path == ".hs" && size > 131072
myTest _ _ _ _ = False

