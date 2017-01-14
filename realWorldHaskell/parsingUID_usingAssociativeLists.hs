
{- passwd mgmt for different uids
 - http://book.realworldhaskell.org/read/data-structures.html-}
import Data.List
import System.IO
import Control.Monad(when)
import System.Exit
import System.Environment(getArgs)


main = do
    -- Load the cli
    args <- getArgs

    -- If not right number of args abort
    when (length args /= 2) $ do
        putStrLn "Syntax: passwd-al filename uid"
        exitFailure

    -- Read the file lazily
    content <- readFile (args !! 0)

    -- Compute the username in pure code
    let username = findByUID content (read (args !! 1))

    -- Display the result
    case username of
        Just x  -> putStrLn x
        Nothing -> putStrLn "Could not find that UID"

-- Given the entire input and a UID, see if we find a username.
findByUID :: String -> Integer -> Maybe String
findByUID content uid = lookup uid process
    where process = map parseLine . lines $ content


-- Convert a colon-seperated line into fields
parseLine :: String -> (Integer, String)
parseLine input = (read (fields !! 2), fields !! 0)
                  where fields = split ':' input

{- | Takes a delimiter and a list. Break up the list based on the
 - delimiter. -}
split :: Eq a => a -> [a] -> [[a]]
-- If the input is empty, the result is a list of empty lists.
-- Find the part of the list before delim and put in "before"
-- The rest of list, including the leading delim, goes
-- in "remainder"

split _ [] = [[]]
split delim str =
    before : case remainder of
                  [] -> []
                  x  -> split delim (tail x)

    where (before, remainder) = span (/= delim) str