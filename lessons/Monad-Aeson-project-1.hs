
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}

import Control.Exception ( Exception, handle, throwIO )
import Data.Typeable ( Typeable )
import Data.Aeson ( decode, encode, FromJSON, ToJSON )
import Data.ByteString.Lazy as B ( ByteString, length, readFile, putStrLn )
import Data.ByteString.Lazy.Char8 as BC( ByteString, pack, unpack )
import GHC.Generics ( Generic )
import Data.Maybe ( isNothing, fromJust )
import System.Directory ( doesFileExist, removeFile )
import Data.Char ( isDigit )
import Control.Monad ( forM_, when )

-- Used for breaking out of a function when a condition is met
data MyException = MyException deriving (Show, Typeable)
instance Exception MyException

type Player = String
type Choice = String

data GameState = GameState
  { currentBoard :: [Choice]
  , currentPlayer :: Player
  } deriving (Show,Generic)

instance FromJSON GameState
instance ToJSON GameState

main :: IO ()
main = do
    jsonData <- returnGameData
    let gameData = if B.length jsonData > 0
                   then (decode jsonData :: Maybe GameState)
                   else (Nothing :: Maybe GameState)
    if isNothing gameData
    then do 
        Prelude.putStrLn "Starting new game."
        Prelude.putStrLn "Board indexes are:"
        mapM_ Prelude.putStrLn ["1|2|3", "-----", "4|5|6", "-----", "7|8|9"]
        let initState = GameState
                        ["Empty" | boardInd <- [1..9]]
                        "XPlayer"
        playGame initState
    else do
        Prelude.putStrLn "Found saved game."
        let initState = fromJust gameData
        printBoard initState
        playGame initState

returnGameData :: IO ByteString
returnGameData = do
  fileExists <- doesFileExist "./game_data"
  if fileExists
  then do
    B.readFile "./game_data"
  else do
    let jsonData = BC.pack ""
    return jsonData

playGame :: GameState -> IO ()
playGame gs = do
    let player = currentPlayer gs
        board = currentBoard gs
        freeFields = getFreeFields gs

    if Prelude.length freeFields /= 0
    then do
        if player == "XPlayer"
        then Prelude.putStrLn "Player X make your choice:"
        else Prelude.putStrLn "Player O make your choice:"

        choice <- getCommand gs freeFields
        if choice == -999
        then Prelude.putStrLn "Quiting game."
        else do
            let newGameState = GameState
                                (if player == "XPlayer"
                                then [if ind /= choice then board !! (ind-1) else "X" | ind <- [1..9]]
                                else [if ind /= choice then board !! (ind-1) else "O" | ind <- [1..9]])
                                (nextPlayer player)
            printBoard newGameState
            check <- checkResult newGameState
            if check == "continue"
            then playGame newGameState
            else main
    else do
        jsonData <- returnGameData
        Prelude.putStrLn "Game is a draw."
        when (B.length jsonData > 0) $ do removeFile "./game_data"

getFreeFields :: GameState -> [Int]
getFreeFields gs = [ind | ind <- [0..8], board !! ind == "Empty"]
    where board = currentBoard gs

getCommand :: GameState -> [Int] -> IO Int
getCommand gs freeFields = do
    command <- getLine
    case command of
        "quit" -> do
                    return (-999)
        "save" -> do
                    let encodedJson = encode gs
                    Prelude.writeFile "./game_data" $ BC.unpack encodedJson
                    getCommand gs freeFields
        _      -> do
                    if Prelude.all isDigit command
                    then getChoice gs command freeFields
                    else do
                        Prelude.putStrLn "This is not a valid command. Try again:"
                        getCommand gs freeFields

getChoice :: GameState -> String -> [Int] -> IO Int
getChoice gs command freeFields = do
    let choice = read command :: Int
    if (choice - 1) `Prelude.elem` freeFields
    then return choice
    else do
        Prelude.putStrLn "This is not a free field. Try again:"
        getCommand gs freeFields

nextPlayer :: Player -> Player
nextPlayer p = if p == "XPlayer"
               then "OPlayer"
               else "XPlayer"

printBoard :: GameState -> IO ()
printBoard gs = do
    let board = currentBoard gs
        stateToString st = case st of
                             "X" -> "X"
                             "O" -> "O"
                             _ -> "-"
        printInd ind = stateToString $ board !! ind
    mapM_ Prelude.putStr [printInd 0,"|", printInd 1,"|", printInd 2, "\n"]
    Prelude.putStrLn "-----"
    mapM_ Prelude.putStr [printInd 3,"|", printInd 4,"|", printInd 5, "\n"]
    Prelude.putStrLn "-----"
    mapM_ Prelude.putStr [printInd 6,"|", printInd 7,"|", printInd 8, "\n"]

checkResult :: GameState -> IO String
checkResult gs = handle (\ MyException -> return "finished") $ do
    jsonData <- returnGameData
    let board = currentBoard gs
        xind = [ind | ind <- [1..9], board !! (ind -1) == "X"]
        oind = [ind | ind <- [1..9], board !! (ind -1) == "O"]
        winnerCombs = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    
    forM_ winnerCombs $ \comb -> do
        let xcheck = and [ind `elem` xind | ind <- comb]
        let ocheck = and [ind `elem` oind | ind <- comb]
        when xcheck $ do
            Prelude.putStrLn "X player has won."
            when (B.length jsonData > 0) $ do removeFile "./game_data"
            throwIO MyException -- breaks out of the checkResult function
        when ocheck $ do
            Prelude.putStrLn "O player has won."
            when (B.length jsonData > 0) $ do removeFile "./game_data"
            throwIO MyException -- breaks out of the checkResult function
    
    return "continue"
