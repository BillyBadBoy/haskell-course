-- Question 1
-- Write a function that checks if the monthly consumption of an electrical device is bigger, equal, or smaller than the maximum allowed and
-- returns a message accordingly. 
-- The function has to take the hourly consumption of an electrical device, the hours of daily use, and the maximum monthly consumption allowed.
-- (Monthly usage = consumption (kW) * hours of daily use (h) * 30 days).
checkConsumption power hoursPerDay monthlyMax
        | monthlyUsage <  monthlyMax = "Using less than max." 
        | monthlyUsage == monthlyMax = "Using exactly max." 
        | monthlyUsage >  monthlyMax = "Using more than max." 
            where
                  monthlyUsage = power * hoursPerDay * 30 


-- Question 2
-- Prelude:
-- We use the function `show :: a -> String` to transform any type into a String.
-- So `show 3` will produce `"3"` and `show (3 > 2)` will produce `"True"`.

-- In the previous function, return the excess/savings of consumption as part of the message.
checkConsumption' p hs max
        | usage <  max = "Using less than max (saving is " ++ show delta ++ ")."
        | usage == max = "Using exactly max."
        | usage >  max = "Using more than max (excess is " ++ show delta ++ ")." 
            where
                  usage = p * hs * 30
                  delta = abs(max - usage)


-- Question 3
-- Write a function that showcases the advantages of using let expressions to split a big expression into smaller ones.
-- Then, share it with other students in Canvas.

-- Heron's formula for findin the area of a trianagle from the length of its sides
areaTriangle :: Double -> Double -> Double -> Double
areaTriangle a b c = let s = (a + b + c) / 2 in
    sqrt (s * (s - a) * (s - b) * (s - c))


-- Question 4
-- Write a function that takes in two numbers and returns their quotient such that it is not greater than 1.
-- Return the number as a string, and in case the divisor is 0, return a message why the division is not
-- possible. To implement this function using both guards and if-then-else statements.  

quotient :: Double -> Double -> String
quotient a b
    | abs a > abs b = show (b / a)
    | abs b > abs a = show (a / b)
    | abs a == abs b = if a == 0 then "Error:division by zero!" else show (a / b)


-- Question 5
-- Write a function that takes in two numbers and calculates the sum of squares for the product and quotient
-- of those numbers. Write the function such that you use a where block inside a let expression and a
-- let expression inside a where block. 

f :: Double -> Double -> Double
f x y = let prodSqr = prod * prod where prod = x * y in 
    prodSqr + quotSqr 
    where quotSqr = let quot = x / y in quot * quot