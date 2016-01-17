type Name = String
type WelcomeWords = String
type LogBook = [String]

-- Tree of any type (the `a` in `Tree a` can be any type. Technially should be instance of `Show` but here ignored for simplicity)
data Tree a = Empty | Node a (Tree a) (Tree a) deriving Show

{- Students are organised as a tree-like structure
          Anderson
          /      \
       Bryan    Derrick
      /
   Carlson
-}

-- represented a tree value (with nested trees)
studentTree = Node "Anderson"
                (Node "Bryan"
                  (Node "Carlson" Empty Empty) Empty)
                (Node "Derrick" Empty Empty)

-- greet :: given a name and a logBook, knows how to produce a welcome pack and do logging
greet :: Name -> LogBook -> (LogBook, WelcomeWords)
greet name logBook = (logBook ++ [newLog], greeting)
                     where
                       newLog = name ++ " has arrived"
                       greeting = "Welcome, " ++ name

{- studentTree is turned into a tree of greetings
welcomeWordsTree =  Node "Welcome, Anderson"
                     (Node "Welcome, Bryan"
                       (Node "Welcome, Carlson" Empty Empty))
                     (Node "Welcome, Derrick" Empty Empty)

-- after greeting, we produce a logBook as well
greetingLogBook =  ["Anderson has arrived",
                    "Bryan has arrived",
                    "Carlson has arrived",
                    "Derrick has arrived"]
-}

greetStudents :: (Name -> LogBook -> (LogBook, WelcomeWords)) -> (Tree Name) -> LogBook -> (LogBook, (Tree WelcomeWords))
greetStudents f Empty logBook = (logBook, Empty)
greetStudents f (Node name left right) logBook =
      let (logBook1, greeting) = f name logBook
          (logBook2, greetedLeft) = greetStudents f left logBook1
          (logBook3, greetedRight) = greetStudents f right logBook2
      in  (logBook3, Node greeting greetedLeft greetedRight)

-- with `greetStudents`, we can greet a tree of students, yielding a LogBook, and a new tree of greetings
-- (finalLogBook, greetedStudents) = greetStudents greet studentTree []


------------------------------------------------------------------------
-- Below is an attempt to solve the same problem using state transition

-- a Greeter of something is someone whoe already knows what greeting to give and knows how to do logging
type Greeter greeting = LogBook -> (LogBook, greeting)

{- example greeter
-- Once told that she will be greeting Carlson, jessica has learned the knowledge of who she will greet and what greeting she will give.
jessica = greet "Carlson"

-- Examples of how a greeter works
jessica []                    ==> (["Carlson has arrived"], "Welcome, Carlson")
jessica ["Bryan has arrived"] ==> (["Bryan has arrived", "Carlson has arrived"],"Welcome, Carlson")
-}

copycatGreeter :: greeting -> Greeter greeting
-- SAME AS: copycatGreeter :: greeting -> LogBook -> (LogBook, greeting)
copycatGreeter something = \logBook -> (logBook, something)
--SAME AS: copycatGreeter something logBook = (logBook, something)
{- make a copycat greeters
dummyGreeter = copycatGreeter "Welcome visitor"
dummyGreeter [] ==> ([], "Welcome visitor")
dummyGreeter ["Bryan has arrived"] ==> (["Bryan has arrived"], "Welcome visitors")

The difference between greeter like jessica and a dummyGreeter is that jessica
knows how to do logging, but the dummy one does not. What's the same is that
they both know what greeting to give.
-}

-- train :: given a greeter who knows what greeting to give and how to do logging,
--          and a skill training that enhances the greeting, we get a more
--          sophisicated greeter who not only knows basic greeting, logging, but
--          also new greeting skills that give enriched greeting.
train :: Greeter greetingA -> (greetingA -> Greeter greetingB) -> Greeter greetingB
train greeter greetingSkill = \logBook ->
  let (loggedBook, greeting) = greeter logBook
      skilledGreeter = greetingSkill greeting
  in skilledGreeter loggedBook

{- alternate names for train: augment, promote, empower, apply, etc.
Note that the following type definitions for `greetingSkill` are equivalent:
1. (greetingA -> Greeter greetingB)
2. (greetingA -> (LogBook -> (LogBook, greetingB))
3. (greetingA -> LogBook -> (LogBook, greetingB))

The majar task of `greetingSkill` is to convert greetingA into greetingB. Its type
is not simply (greetingA -> greetingB), and this is because we want to make a new
greeter based on existing greeter, the behaviour of which is defined in its function
definition and cannot be easily modified. In fact, we would like to separate the
behaviour by leaving the logic of processing of greetingA in the definition of
`greeter` but rather, enhance/train it by introducing additional behaviour.
jessica = greet "Carlson"
trainedJessica = train jessica (\greeting logBook -> (logBook, "Good morning! and " ++ greeting))
-- same as below
trainedJessica = train jessica (\greeting -> copycatGreeter "Good morning! and " ++ greeting)

-- then `trainedJessica []` ==> (["Carl has arrived"], "Good morning! and Welcome, Carl")
--      `trainedJessica ["Bryan has arrived"]` ==> (["Bryan has arrived","Carlson has arrived"],
                                                    "Good morning! and Welcome, Carlson")

-- In above example, `jessica` already knows how to write logBookThe whereas `skill` part focuses on converting greetings
--    which is a skill that jessica needs to learn in order to do more sophisicated work. From the definition of
--    the `skill` you can see it does not change logBook at all, it only converts greeting.
-- Combined together, i.e., jessica augmented with training, she now knows how to write logBook as well as converting greetings.
-- In other words, `train` glues two skills together to make a new greeter:
--   1. how to do logging, i.e. update state; 2. how to produce sophisicated greeting
-}

-- makeTreeGreeter :: given a greet function, a tree of names, produces a greeter who knows how to greet all of them
makeTreeGreeter :: (Name -> LogBook -> (LogBook, WelcomeWords)) -> (Tree Name) -> Greeter (Tree WelcomeWords)
makeTreeGreeter f Empty = copycatGreeter Empty
makeTreeGreeter f (Node name Empty Empty) =
  f name `train` \greeting -> copycatGreeter (Node greeting Empty Empty)
makeTreeGreeter f (Node name left right) =
  f name `train`
    \greeting -> leftGreeter `train`
      \leftGreeted -> rightGreeter `train`
        \rightGreeted -> copycatGreeter (Node greeting leftGreeted rightGreeted)
    where
      leftGreeter = makeTreeGreeter f left
      rightGreeter = makeTreeGreeter f right

{-
the pattern here is that we keep training the greeter `f name` by enhancing the
 `value` part from previous greeter while leave the `state` or `logBook` part to
  be passed through all stages silently.
-}

-- makeTreeGreeter greet studentTree []
