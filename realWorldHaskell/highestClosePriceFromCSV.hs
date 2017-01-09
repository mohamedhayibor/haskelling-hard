import qualified Data.ByteString.Lazy.Char8 as L

closing :: L.ByteString -> Maybe Int
closing = readPrice . (!! 4) . L.split ','

readPrice :: L.ByteString -> Maybe Int
readPrice str =
    case L.readInt str of
        Nothing             -> Nothing
        Just (dollars,rest) ->
            case L.readInt (L.tail rest) of
               Nothing                 -> Nothing
               Just (cents, more)      ->
                   Just (dollars * 100 + cents)


highestClose :: L.ByteString -> Maybe Int
highestClose = maximum . (Nothing: ) . map closing . L.lines


highestCloseFrom :: FilePath -> IO ()
highestCloseFrom path = do
    contents <- L.readFile path
    print (highestClose contents)


{- Sample csv data
Date,Open,High,Low,Close,Volume,Adj Close
2008-08-01,20.09,20.12,19.53,19.80,19777000,19.80
2008-06-30,21.12,21.20,20.60,20.66,17173500,20.66
2008-05-30,27.07,27.10,26.63,26.76,17754100,26.76
2008-04-30,27.17,27.78,26.76,27.41,30597400,27.41
-}