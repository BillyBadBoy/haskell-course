
-- Question 1
-- Write a multiline comment below.
{-
multi
line
comment
-}

-- Question 2
-- Define a function that takes a value and multiplies it by 3.
multiplyBy3 x = 3 * x

-- Question 3
-- Define a function that calculates the area of a circle.
areaCircle r = pi * r ^ 2

-- Question 4
-- Define a function that calculates the volume of a cylinder by composing the previous function together with the height of the cylinder. 
volumeCylinder h r = h * areaCircle r

-- Question 5
-- Define a function that takes the height and radius of a cylinder and checks if the volume is greater than or equal to 42.
volAtLeast42 h r = volumeCylinder h r >= 42

