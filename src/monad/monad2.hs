data Term = Con Int | Div Term Term

answer, error :: Term

answer = (Div (Div (Con 1972) (Con 2)) (Con 23))
error = (Div (Con 1) (Con 0))

type State = Int
type M a = State -> (a, State)

eval :: Term -> M Int
eval (Con a) x = (a, x)
eval (Div t u) x = let (a, y) = eval t x in
                   let (b, z) = eval u y in
                   (a `div` b, z + 1)


