type Name = String
type Greeting = String
type LogBook = [String]

-- Tree of any type (the `a` in `Tree a` can be any type. Technially should be instance of Show but here ignored for simplicity)
data Tree a = Empty | Node a (Tree a) (Tree a) deriving Show

{- Students are organised as a tree-like structure
          Anderson
          /      \
       Bryan    Emily
      /     \
   Carlson  Derrick
-}

-- represented a tree value (with nested trees)
studentTree = Node "Anderson"
                (Node "Bryan"
                  (Node "Carlson" Empty Empty)
                  (Node "Derrick" Empty Empty))
                (Node "Isabella" Empty Empty)

{- studentTree is turned into a tree of greetings
greetingTree =  Node "Welcome, Alessandra"
                  (Node "Welcome, Anderson"
                    (Node "Welcome, Brett" Empty Empty)
                    (Node "Welcome, Carlson" Empty Empty))
                  (Node "Welcome, Isabella" Empty Empty)

-- after greeting, we produce a logBook as well
greetingLogBook =  ["Anderson has arrived",
                    "Bryan has arrived",
                    "Carlson has arrived",
                    "Derrick has arrived",
                    "Emily has arrived"]
-}


greet :: Name -> LogBook -> (LogBook, Greeting)
greet name logBook = (logBook ++ [newLog], greeting)
                     where
                       newLog = name ++ " has arrived"
                       greeting = "Welcome, " ++ name

greetStudents :: (Name -> LogBook -> (LogBook, Greeting)) -> (Tree Name) -> LogBook -> (LogBook, (Tree Greeting))
greetStudents f Empty logBook = (logBook, Empty)
greetStudents f (Node name left right) logBook =
      let (logBook'  , greeting) = f name logBook
          (logBook'' , greetedLeft) = greetStudents f left logBook'
          (logBook''', greetedRight) = greetStudents f right logBook''
      in  (logBook''', Node greeting greetedLeft greetedRight)

-- with `greetStudents`, we can greet a tree of students, yielding a LogBook, and a new tree of greetings
-- (actualFinalLogBook, actualGreetedStudents) = greetStudents greet studentTree []

type Greeter sth = LogBook -> (LogBook, sth)

makeGreeter :: sth -> LogBook -> (LogBook, sth)
-- SAME AS: makeGreeter :: a -> Greeter a
makeGreeter something = \logBook -> (logBook, something)
--SAME AS: makeGreeter something logBook = (logBook, something)

liftUp :: Greeter thingA -> (thingA -> Greeter thingB) -> Greeter thingB
greeter `liftUp` knowledge = \logBook ->
  let (logBook', greeting)    = greeter logBook
      greeter' = knowledge greeting
  in greeter' logBook'

-- alternate names for liftUp: promote, empower, augment, etc.

makeTreeGreeter :: (Name -> LogBook -> (LogBook, Greeting)) -> (Tree Name) -> Greeter (Tree Greeting)
makeTreeGreeter f (Node name Empty Empty) =
  f name `liftUp` \greeting -> makeGreeter (Node greeting Empty Empty)

makeTreeGreeter f (Node name lhs rhs) =
  f name `liftUp`
    \greeting -> makeTreeGreeter f lhs `liftUp`
      \leftGreeted -> makeTreeGreeter f rhs `liftUp`
        \rightGreeted -> makeGreeter (Node greeting leftGreeted rightGreeted)

-- makeTreeGreeter greet studentTree []
