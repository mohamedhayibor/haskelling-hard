import Data.Char (toUpper)
import System.IO

main = do
       hin  <- openFile "input.txt" ReadMode
       hout <- openFile "output.txt" WriteMode
       mainLoop hin hout
       hClose hin
       hClose hout


mainLoop :: Handle -> Handle -> IO()
mainLoop hin hout =
    do ineof <- hIsEOF hin
       if ineof
           then return ()
           else do inpStr <- hGetLine hin
                   hPutStrLn hout (map toUpper inpStr)
                   mainLoop hin hout