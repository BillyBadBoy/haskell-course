-- Question 1
-- Lets say you have the nested values defined bellow. How would you get the value of
-- 4 by using only pattern matching in a function?

nested :: [([Int], [Int])]
nested = [([1,2],[3,4]), ([5,6],[7,8])]

f :: [([Int], [Int])] -> Int
f ((_, [_, x]):_) = x
f _               = 0    


-- Question 2
-- Write a function that takes a list of elements of any type and, if the list has 3 or more elements, it
-- removes them. Else, it does nothing. Do it two times, one with multiple function definitions and one with
-- case expressions.

f2 :: [a] -> [a]
f2 (x:y:z:_) = []
f2 as        = as 

f2' :: [a] -> [a]
f2' v = case v of
    (x:y:z:_) -> []
    as        -> as


-- Question 3
-- Create a function that takes a 3-element tuple (all of type Integer) and adds them together

f3 :: (Integer, Integer, Integer) -> Integer
f3 (a, b, c) = a + b + c

-- Question 4
-- Implement a function that returns True if a list is empty and False otherwise.

f4 :: [a] -> Bool
f4 [] = True
f4 _  = False

-- Question 5
-- Write the implementation of the tail function using pattern matching. But, instead of failing if
-- the list is empty, return an empty list.

f5 :: [a] ->[a]
f5 (a:as) = as
f5 []     = []

-- Question 6
-- write a case expression wrapped in a function that takes an Int and adds one if it's even. Otherwise does nothing. 
-- (Use the `even` function to check if the number is even.)

f6 :: Int -> Int
f6 n = case even n of
    True  -> n + 1
    False -> n
