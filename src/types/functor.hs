data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Read, Eq)

instance (Show a) => Show (Tree a) where
  show EmptyTree = "{}"
  show (Node n left right) = "{" ++ show n ++ ": " ++ show left ++ ", " ++ show right ++ "}"

instance Functor Tree where
  fmap f EmptyTree = EmptyTree
  fmap f (Node x left right) = Node (f x) (fmap f left) (fmap f right)

singleton :: a -> Tree a  
singleton x = Node x EmptyTree EmptyTree  
  
treeInsert :: (Ord a) => a -> Tree a -> Tree a  
treeInsert x EmptyTree = singleton x  
treeInsert x (Node a left right)   
    | x == a = Node x left right  
    | x < a  = Node a (treeInsert x left) right  
    | x > a  = Node a left (treeInsert x right)  


nums = [8,6,4,1,7,3,5] 
numsTree = foldr treeInsert EmptyTree nums  

inc = (+1)
incNumsTree = fmap inc numsTree
