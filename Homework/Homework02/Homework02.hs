
-- Question 1
-- Add the type signatures for the functions below and then remove the comments and try to compile.
-- (Use the types presented in the lecture.)

f1 :: Double -> Double -> Double -> Double 
f1 x y z = x ** (y/z)

f2 ::  Double -> Double -> Double -> Double 
f2 x y z = sqrt (x/y - z)

f3 :: Bool -> Bool -> [Bool] 
f3 x y = [x == True] ++ [y]

f4 :: [Int] -> [Int] -> [Int] -> Bool
f4 x y z = x == (y ++ z)


-- Question 2
-- Why should we define type signatures of functions? How can they help you? How can they help others?
-- Answer 2:
-- [1] to act as simple documentation
-- [2] to simplify type error messages

-- Question 3
-- Why should you define type signatures for variables? How can they help you?
-- Answer 3:
-- [1] to act as simple documentation
-- [2] to specify type precisely (e.g. for numeric types)


-- Question 4
-- Are there any functions in Haskell that let you transform one type to the other? Try googling for the answer.
-- Answer 4
-- e.g numeric conversion functions: fromInteger, toInteger, float2Double, double2Float

-- Question 5
-- Can you also define in Haskell list of lists? Did we showed any example of that? How would you access the inner
-- most elements?
-- Answer 5
-- [1] a list of lists like this:
listOfListOfInts :: [[Int]]
listOfListOfInts = [[1,2,3], [4,5,6]]
-- [2] a list strings is actually a list of lists of Char:
name :: [[Char]]
name = ["Alan", "Turing"]
-- [3] you can access innermost elemnents by applying the list accessor multuple times:
initials = [name !! 0 !! 0] ++ [name !! 1 !! 0] -- "AT" 

