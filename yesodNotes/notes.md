QuasiQuotes (QQ): minor extension of template Haskell that let us embed arbitrary content within our Haskell source files.

Front controller pattern: a controller that handles all requests for a website. (for flexibility and reuse code redundancy)
Benefits:

* Centralized control: avoids using multiple controllers (users tracking and security)
* Thread-safety
* Configurability

> May decrease in performance if searching the database or XML documents

```hs
mkYesod "Hello World" [parseRoutes|
/ HomeR GET
|]
```

> mkYesod is a template Haskell function, and parseRoutes is a QuasiQuoter.

```hs
-- Hello World example
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE QuasiQuotes         #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeFamilies        #-}

import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]

main :: IO ()
main = warp 3000 HelloWorld
```

YesodDispatch:
1. Parse the request
2. Choose a handler function
3. Run the handler function

> Most of the code you write in Yesod lives in handler functions. Where you process user input, perform database queries and create responses.

Hamlet is the default HTML templating engine.

Every Yesod application has a foundation datatype (HelloWorld). This datatype must be an instance of the Yesod typeclass, which provides a central place for declaring a number of different settings controlling the execution of our application.

Can store more useful information:

1. A database connection pool
2. Settings loaded from a config file
3. An HTTP connection manager
4. A random number generator


```hs
<a href=@{ Page1 }>Go to page 1!
```

Page1R is a data constructor. By making each resource a data constructor, we have `type-safe Urls`.

> By using at sign interpolation (@{...}), Yesod automatically renders those values to textual urls before sending things off to the user.

You can move urls around without ever breaking links. (Type safety)

##### Shakespearean templates

Hamlet: provides syntax for generating HTML and allows for basic control structures: conditionals, looping and maybes. Theyall support type-safe URLs.

html, Julius: Javascript, Cassuis & Lucius: CSS

Types help protect us from XSS attacks.

```hs
data MyRoute = Home | Time

renderMyRoute :: MyRoute -> Text
renderMyRoute Home = "http://..."
renderMyRoute Time = "..."
```

URL rendering functions are more complicated than this: need to address query string parameters, handle records within the constructor. (Yesod will automatically create render functions)

```hs
<a href=@{Time}>The time
-- would translate to
\render -> mconcat ["<a href='", render Time, "'>The time</a>"]
```

```
<a>Paragraph <i>italic</i> end.</a>
-- translate to
<a>Paragraph #
  <i>italic
  / end.
```

The backslash is ignored. (any tag will be treated as plain text)

```
<p>Welcome back #{name}
```

`#{}` the way we do variable interpolation

Url variant that allows you to embed query string parameters. Could be useful for creating paginated responses.

> add question mark `(@?{...})`

```hs
<a href=@?{(SomePage, [("page", pack $ show $ currPage + 1)])}>Next
```

3 ways to call out to Shakespeare from Haskell code.

* quasiquotes: allow to embed arbitrary content within your Haskell > for it to be compiled at compile time.
* external file: template code in a seperate file referenced via template haskell
* reload mode

##### Yesod typeclasses

In order to convert type-safe URLs into text values: Yesod uses two helper functions:

* renderRoute: converts a value into a list of path pieces.
* joinPath: takes 4 args: foundation value | application root | list of path segments | query string params


Routing and dispatch may be considered as the core of Yesod.

##### Forms

Applicative and monadic forms handle both the generation of your HTML code and the parsing of user input.

##### Sessions

Http is a stateless protocol. Benefits: easier scalability - caching

The encryption prevents the user from inspecting the data, and the signature ensures that the session cannot be tampered with.

Storing data in a cookie:

1. No server side database lookup is required to service request.
2. scale horizontally: each request contains all the information we need to send a response.
3. To avoid undue bandwidth overhead, production sites can serve their static content from a seperate domain name, thereby skipping transmission of the cookie for each request.

> If you really need massive storage for a user, it best to store a lookup key in the session, and put the actual data in a database.


Your app will get the encryption key from the client `client-session-key.aes` (client storage) and giving a session a two hour timeout.

> disabling sessions can give performance boost. (caution: will also remove `Cross-Site Request Forgery` protection feature)

```hs
instance Yesod App where
    makeSessionBackend _ = return Nothing
```

###### ultimate destination:

```
req -> no auth -> login -> back to req page
```

> Sessions are the primary means by which we bypass the stateless imposed by Http.

#### Persistent

> Yesod's answer to data storage, type safe, universal data store interface for Haskell.

* Database-agnostic: first class support for PostgreSQL, SQLite, MySQL and MongoDB with experimental redis support.
* Convenient data modeling: lets you model relationships and use them in type-safe ways. (default type safe does not support joins)
* automatically perfom database migrations

All database actions require a parameter which is an instance of `PersistStore`. (where all the transactions from `PersistValue` to database-specific values occur, where SQL query generation happens.

runSqlite: creates a single connection to a database using its supplied connection string.

> `:memory:` uses an in-memory database.

All of the SQL backends share the same instance of `PersistStore: SqlBackend`. `runSqlite` then provides the SqlBackend value as an environment parameter to the action via runReaderT.

```hs
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
[persistLowerCase|
Person
    name String
    age  Int
    deriving Show

Car
    color String
    make  String
    model String
    deriving Show
|]

main :: IO ()
main = runSqlite ":memory:" $ do runMigration migrateALl
```

mkMigrate is a template Haskell function which creates a new function that will automatically call migrate on all entities defined in the persist block.

The `share` function is just a little helper that passes the information from the persist block to each Template Haskell function and concatenates the results.

With persistent we get all the benefits of pattern matching, currying ...


