data Term = Con Int | Div Term Term

answer, error :: Term

answer = (Div (Div (Con 1972) (Con 2)) (Con 23))
error = (Div (Con 1) (Con 0))

type Exception = String
data M a = Raise Exception | Return a

eval :: Term -> M Int
eval (Con a) = Return a
eval (Div t u) = case eval t of
                   Raise e -> Raise e
                   Return a ->
                     case eval u of
                       Raise e -> Raise e
                       Return b ->
                         if b == 0
                           then Raise "divide by zero"
                           else Return (a `div` b)


showM :: M Int -> String
showM (Return a) = show a
showM (Raise s) = s
