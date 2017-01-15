
{- Function that recurses into a directory tree,
 - and returns a list of the number of entries
 - it finds at each level of the tree -}


module CountEntries (listDirectory, countEntriesTrad) where


import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import Control.Monad (forM, liftM)


listDirectory :: FilePath -> IO [String]
listDirectory = liftM (filter notDots) . getDirectoryContents
    where notDots p = p /= "." && p /= ".."


countEntriesTrad :: FilePath -> IO [(FilePath, Int)]
countEntriesTrad path = do
    contents <- listDirectory path
    rest     <- forM contents $ \name -> do
                  let newName = path </> name
                  isDir <- doesDirectoryExist newName
                  if isDir
                    then countEntriesTrad newName
                    else return []
    return $ (path, length contents) : concat rest