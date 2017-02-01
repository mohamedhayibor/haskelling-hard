More steps for a production-quality site setup:

* Config file parsing
* Signal handling (nix)
* More efficient static file serving
* A good file layout

A subsite is a collection of routes and their handlers that can be easily inserted into a master site. By using type classes, it is easy to ensure that the master site provides certain capabilities and to access the default site layout.

In Yesod the ground floor WAI (Web Application Interface). It sits behind a web handler such a web server and a web app.

Record wildcard syntax: `App {..}` convenient when we want to deal with a number of different fields in a datatype.

In order to define a subsite, we first need to create a foundation type for the subsite, the same as we would do for a normal Yesod application.


Working with Persistent
---------

Different approaches to querying the database:

* query based on a numeric ID
* filter

> a query that can return only 0 or 1 results will use a `Maybe` wrapper, whereas a query returning many results will return a list.

### Fetching by ID

The simplest in Persistent:

```hs
personId <- insert $ Person "John" "Doe" 32
maybePerson <- get personId
case maybePerson of
    Nothing -> liftIO $ putStrLn "Nobody there"
    Just Person -> liftIO $ print person
```

### Fetching by unique constraint

`getBy` is almost to get except:

1. it takes a uniqueness constraint: instead of an ID it takes a Unique value.
2. returns an `Entity` instead of a value. `Entity`: a combination of database ID and value

```hs
personId <- insert $ Person "Micheal" "Clayton" 43
maybePerson <- getBy PersonName "Micheal" "Clayton"
case mayPerson of
    Nothing ->` liftIO $ putStrLn "None"
    Just (Entity personId person) -> liftIO $ print person
```

### Select Functions

```hs
people <- selectList [PersonAge >. 25, PersonAge <=. 30] []
liftIO $ print people
```
[see more details](http://www.yesodweb.com/book/persistent)


## Insert

`insert` function: you give it a value it gives back an id

For the IDs: using plain old Algebraic Data Types

## Update

```hs
personId <- insert $ Person "Micheal" "Clayton" 43
update personId [PersonAge =. 27]
```

Alternative to an assignment

```hs
haveBirthday personId = update personId [PersonAge +=. 1]
```

> use `updateWhere` to update many rows at the same time.

```hs
updateWhere [PersonLastName ==. "Clayton"] [PersonAge +=. 1]
```

To replace a value in the DB

```hs
personId <- insert $ Person "Napoleon" "Bonaparte" 999
replace personId $ Person "Micheal" "clayton" 43
```

## Delete

delete, deleteBy, deleteWhere

## Relations

Reference between data-types can be done by embedding an ID in the related entity.

one to many relationship:

```hs
Person
    name String
    deriving Show
Car
    ownerId PersonId
    name String
    deriving Show
```

For many to many relationships, you need a join entity, which has one to many relationship with each of the original tables.

GHC stage restriction:

Template Haskell generated code cannot be used in the same module it was created in.

[From Yesod book](http://www.yesodweb.com/book/)
