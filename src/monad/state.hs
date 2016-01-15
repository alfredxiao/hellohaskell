type Name = String
type Greeting = String
type LogBook = [String]
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Eq)

newStudents = Node "Alessandra"
                (Node "Anderson"
                  (Node "Brett" EmptyTree EmptyTree)
                  (Node "Carlson" EmptyTree EmptyTree))
                (Node "Isabella" EmptyTree EmptyTree)


expectedGreetedStudents = Node "Welcome, Alessandra"
                    (Node "Welcome, Anderson"
                      (Node "Welcome, Brett" EmptyTree EmptyTree)
                      (Node "Welcome, Carlson" EmptyTree EmptyTree))
                    (Node "Welcome, Isabella" EmptyTree EmptyTree)

expectedFinalLogBook = ["Alessandra has arrived",
                        "Anderson has arrived",
                        "Brett has arrived",
                        "Carlson has arrived",
                        "Isabella has arrived"]

year2Student :: Name -> LogBook -> (LogBook, Greeting)
year2Student name logBook = (logBook ++ [newLog], greeting)
                             where
                               newLog = name ++ " has arrived"
                               greeting = "Welcome, " ++ name

greetNewStudents :: (Name -> LogBook -> (LogBook, Greeting)) -> (Tree Name) -> LogBook -> (LogBook, (Tree Greeting))
greetNewStudents f EmptyTree logBook = (logBook, EmptyTree)
greetNewStudents f (Node name left right) logBook =
      let (logBook'  , greeting) = f name logBook
          (logBook'' , greetedLeft) = greetNewStudents f left logBook'
          (logBook''', greetedRight) = greetNewStudents f right logBook''
      in  (logBook''', Node greeting greetedLeft greetedRight)

(actualFinalLogBook, actualGreetedStudents) = greetNewStudents year2Student newStudents []

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

greetNewStudentsV2 :: (Name -> LogBook -> (LogBook, Greeting)) -> (Tree Name) -> Greeter (Tree Greeting)
greetNewStudentsV2 f (Node name EmptyTree EmptyTree) =
  f name `liftUp` \greeting -> (\logBook ->  (logBook, (Node greeting EmptyTree EmptyTree)))

greetNewStudentsV2 f (Node name lhs rhs) =
  f name `liftUp`
    \greeting -> greetNewStudentsV2 f lhs `liftUp`
      \lhs' -> greetNewStudentsV2 f rhs `liftUp`
        \rhs' -> \logBook -> (logBook, (Node greeting lhs' rhs'))
