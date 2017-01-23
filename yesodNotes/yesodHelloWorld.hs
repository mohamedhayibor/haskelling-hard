{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}

import           Data.Text (Text)
import           Yesod

data App = App

mkYesod "App" [parseRoutes|
/hello/#Text HomeR GET
|]

instance Yesod App

getHomeR :: Text -> Handler Html
getHomeR name = defaultLayout [whamlet|<h1>Hellow #{name}!!!|]

main :: IO ()
main = warp 3000 App