data Tree a
  = Leaf a | Branch (Tree a) (Tree a) deriving (Show, Eq)

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f (Leaf a) = Leaf (f a)
mapTree f (Branch lhs rhs) = Branch (mapTree f lhs) (mapTree f rhs)

mapTreeState :: (a -> state -> (state, b)) -> Tree a -> state -> (state, Tree b)
mapTreeState f (Leaf a) state =
      let (state', b) = f a state
      in  (state', Leaf b)
mapTreeState f (Branch lhs rhs) state =
      let (state' , lhs') = mapTreeState f lhs state
          (state'', rhs') = mapTreeState f rhs state'
      in  (state'', Branch lhs' rhs')

salaryData = Branch (Branch (Leaf 100) (Leaf 120)) (Leaf 150)

increaseSalary = (+10)
increasedSalaryData = mapTree increaseSalary salaryData

sumAndIncrease x total = (total + x, x + 10)
sumAndIncreasedSalaryData = mapTreeState sumAndIncrease salaryData 0

type StateT st a = st -> (st, a)
makeStateT :: a -> StateT st a
makeStateT a = \stateX -> (stateX, a)

andThen :: StateT st a -> (a -> StateT st b) -> StateT st b
initTransformer `andThen` knowledge = \initState ->
  let (nextState, a)    = initTransformer initState
      targetTransformer = knowledge a
  in targetTransformer nextState

mapTreeStateT :: (a -> StateT st b) -> Tree a -> StateT st (Tree b)
mapTreeStateT f (Leaf a) =
  f a `andThen` \b -> makeStateT (Leaf b)
mapTreeStateT f (Branch lhs rhs) =
  mapTreeStateT f lhs `andThen` \lhs' ->
  mapTreeStateT f rhs `andThen` \rhs' ->
  makeStateT (Branch lhs' rhs')

sumAndIncreasedSalaryDataT = mapTreeStateT sumAndIncrease salaryData 0
