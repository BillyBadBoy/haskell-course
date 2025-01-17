import Data.List
import System.CPUTime (getCPUTime)
import System.Directory (doesFileExist, listDirectory)
import Text.XHtml (thead)
import Control.Monad (filterM, when, unless)
import System.Posix (PathVar(PathNameLimit))
import System.FilePath.Posix (joinPath)

{-
We imported some functions that you'll need to complete the homework.
FilePath is just a synonym for String. Although, make sure to follow the standard path
representation when using them (https://en.wikipedia.org/wiki/Path_(computing).
getCPUTime    :: IO Integer
doesFileExist :: FilePath -> IO Bool
listDirectory :: FilePath -> IO [FilePath]
You can hover over the functions to know what they do.
-}

{-
-- Question 1 --
Define an IO action that counts the number of files in the current directory
and prints it to the terminal inside a string message.
-}

-- #################################################
-- assume we don NOT include files in sb-directories
-- #################################################

listFiles :: IO ()
listFiles = do
  allPaths <- listDirectory "."
  numFiles <- countFiles allPaths
  putStrLn $ "Directory contains " ++ show numFiles ++ " files."

  where
    countFiles :: [FilePath] -> IO Int
    countFiles []    = return 0
    countFiles (h:t) = do
      headCount <- doesFileExist h >>= (\b -> return $ if b then 1 else 0)
      tailCount <- countFiles t
      return $ headCount + tailCount


-- alternative using filterM
listFiles' :: IO ()
listFiles' = do
  allPaths  <- listDirectory "."
  filePaths <- filterM doesFileExist allPaths
  putStrLn $ "Directory contains " ++ show (length filePaths) ++ " files."

{-
-- Question 2 --
Write an IO action that asks the user to type something, then writes the message
to a file called msg.txt, and after that, it reads the text from the msg.txt
file and prints it back. Use the writeFile and readFile functions.
-}

createMsg :: IO ()
createMsg = do
  putStrLn "Enter a message:"
  getLine >>= writeFile "./msg.txt"
  readFile "./msg.txt" >>= putStrLn


{-
-- Context for Questions 3 and 4 --
In cryptography, prime numbers (positive integers only divisible by themselves and 1) play a fundamental
role in providing unbreakable mathematical structures. These structures, in turn, are leveraged to
establish secure encryption.
But, generating primes is a computational straining problem, as we will measure in the following exercise.
This is because, to know whether a number is a prime number, you first need to know all the previous primes
and then check that they are not a divisor of this number. So, this problem gets bigger and bigger!
Our lead cryptographer provided us with 3 different algorithms (primes1, primes2, and primes3). All three
correctly produce a list of all the prime numbers until a limit (that we provide as a parameter).
Our job is not to understand these algorithms but to measure which is the fastest and print the largest
prime number below our limit. Do it step by step, starting with question 3.
-}

primes1 :: Integer -> [Integer]
primes1 m = sieve [2 .. m]
 where
  sieve [] = []
  sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p > 0]

primes2 :: Integer -> [Integer]
primes2 m = sieve [2 .. m]
 where
  sieve (x : xs) = x : sieve (xs \\ [x, x + x .. m])
  sieve [] = []

primes3 :: Integer -> [Integer]
primes3 m = turner [2 .. m]
 where
  turner [] = []
  turner (p : xs) = p : turner [x | x <- xs, x < p * p || rem x p /= 0]

{-
-- Question 3 --
Define an IO action that takes an IO action as input and calculates the time it takes to execute.
Use the getCPUTime :: IO Integer function to get the CPU time before and after the IO action.
The CPU time here is given in picoseconds (which is 1/1000000000000th of a second).
-}

timeIO :: IO a -> IO ()
timeIO action = do
  t1 <- getCPUTime
  action
  t2 <- getCPUTime
  putStrLn $ "Action took " ++ show ((t2 - t1) `div` 1000000000000) ++ " seconds."

{-
-- Question 4 --
Write an action that retrieves a value from the standard input, parses it as an integer,
and compares the time all three algorithms take to produce the largest prime before the
limit. Print the number and time to the standard output.
-}

benchmark :: IO ()
benchmark = do
  limit :: Integer <- readLn

  timeIO $ run "primes1" primes1 limit
  timeIO $ run "primes2" primes2 limit
  timeIO $ run "primes3" primes3 limit

  where
    run name fn limit = do
      putStrLn $ "\nRunning " ++ name ++ ":"
      let primes = fn limit
      putStrLn $ "Largest prime found: " ++ show (last primes)

-- sample output:

-- ghci> benchmark
-- 20000

-- Running primes1:
-- Largest prime found: 19997
-- Action took 2 seconds.

-- Running primes2:
-- Largest prime found: 19997
-- Action took 15 seconds.

-- Running primes3:
-- Largest prime found: 19997
-- Action took 2 seconds.


{-
 -- Question 5 -- EXTRA CREDITS -- (In case the previous ones were too easy)
Write a program that prints the directory tree structure from the current folder.
Below you can see an example output of how such a structure looks like:
.
├── foo1.hs
├── foo2.hs
├── bar1
    ├── bar2
    ├── foo3.hs
    ├── foo4.hs
    └── bar3
        └── foo5.hs
└── bar5
    ├── bar6
    ├── foo6.hs
    └── foo7.hs
HINT: You can use the function doesFileExist, which takes in a FilePath and returns
True if the argument file exists and is not a directory, and False otherwise.
-}

type Path = [String]

printCurrentDir :: IO ()
printCurrentDir = do
  files <- listDirectory "."
  putStrLn "."
  printDir 0 $ map (: []) files

  where

  printDir :: Int -> [Path] -> IO ()
  printDir _         [] = return ()
  printDir depth    [p] = printItem depth True  p
  printDir depth (p:ps) = printItem depth False p >> printDir depth ps

  printItem :: Int -> Bool -> Path -> IO ()
  printItem depth isLast path = do

    -- print item
    putStrLn $ replicate (4 * depth) ' ' ++ (if isLast then "└── " else "├── ") ++ head path

    -- print child items (if item is directory)
    let fName = joinPath $ reverse path
    isFile <- doesFileExist fName
    files  <- if isFile then return [] else listDirectory fName
    printDir (depth + 1) $ map (: path) files

-- sample output: 

-- ghci> printCurrentDir 
-- .
-- ├── Homework.hs
-- ├── dir1
--     ├── f1
--     └── f2
-- └── dir2
--     ├── f3
--     ├── f4
--     └── dir3
--         └── f5