-- Question 1
-- Investigate the `Bounded` type class. What behaviours it provides?

isMax :: (Eq a, Bounded a) => a -> Bool
isMax = (==) maxBound

isMin :: (Eq a, Bounded a) => a -> Bool
isMin =  (==) minBound

-- Question 2
-- The types Int and Word belong to the same type classes. What is the difference
-- between them? Check maybe the maxBound and minBound parameter for both types.

-- -9223372036854775808 <= Int  <=  9223372036854775807
--                    0 <= word <= 18446744073709551615

-- Question 3
-- Investigate the `Enum` type class. What behaviours provides?

nextButOne :: Enum a => a -> a
nextButOne = succ . succ 

beforeAndAfter :: Enum a => a -> (a, a)
beforeAndAfter x = (pred x, succ x) 

-- Question 4
-- Add type signatures to the functions below and use type variables and type classes.
-- Then uncomment the functions and try to compile.

f1 :: (Show a, Fractional a) => a -> a -> String -> String
f1 x y z = show (x / y) ++ z

f2 :: (Bounded a, Enum a, Eq a) => a -> a
f2 x = if x == maxBound then minBound else succ x

-- Question 5
-- Investigate the numeric type classes to figure out which behaviors they provide to change between numeric types.

-- fromIntegral :: (Num b, Integral a) => a -> b
-- fromInteger  :: Num a => Integer -> a
-- toInteger    :: Integral a => a -> Integer
-- realToFrac   :: (Real a, Fractional b) => a -> b
-- fromRational :: Fractional a => Rational -> a
-- toRational   :: Real a => a -> Rational

-- ceiling  :: (RealFrac a, Integral b) => a -> b
-- floor    :: (RealFrac a, Integral b) => a -> b
-- truncate :: (RealFrac a, Integral b) => a -> b
-- round    :: (RealFrac a, Integral b) => a -> b

-- float2Double :: Float  -> Double
-- double2Float :: Double -> Float

