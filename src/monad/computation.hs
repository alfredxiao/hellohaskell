data Failable a = Success a | Fail String


class Computation c where
    success :: a -> c a
    failure :: String -> c a
    augment :: c a -> (a -> c b) -> c b
    combine :: c a -> c a -> c a


instance Computation Maybe where
    success = Just
    failure = const Nothing
    augment (Just x) f = f x
    augment Nothing  _ = Nothing
    combine Nothing y = y
    combine x _ = x
