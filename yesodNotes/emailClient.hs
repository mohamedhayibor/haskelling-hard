{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE OverloadedStrings      #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE QuasiQuotes            #-}

import               Control.Applicative
import               Data.Text (Text)
import               Data.Time
import               Yesod

newtype UserId = UserId Int deriving (Show)

data App = App

mkYesod "App" [parseRoutes|
/ HomeR POST GET
|]

instance Yesod App

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

type Form a = Html -> MForm Handler (FormResult a, Widget)

data Email = Email
    { toAddress     :: Text
    , emailTitle    :: Text
    , emailContents :: Textarea
    , emailUser     :: UserId
    , emailTime     :: UTCTime
    } deriving (Show)

form :: UserId -> Form Email
form userId = renderDivs $ Email
    <$> areq textField "Receiver's address" Nothing
    <*> areq textField "Email Title" Nothing
    <*> areq textareaField "Email Contents" Nothing
    <*> pure userId
    <*> lift (liftIO getCurrentTime)

-- refer to http://www.yesodweb.com/book/sessions
-- TODO to clear and redirect to homepage

getHomeR :: Handler Html
getHomeR = do
    let userId = UserId 5 -- auth assignment
    ((res, widget), enctype) <- runFormPost $ form userId
    defaultLayout
        [whamlet|
            <p>Previous result: #{show res}
            <form method=post action=@{HomeR} enctype=#{enctype}>
                ^{widget}
                <input type=submit>
        |]

postHomeR :: Handler Html
postHomeR = getHomeR

main :: IO ()
main = warp 3000 App
