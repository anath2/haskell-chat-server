module Server
  (
    processConnection
  ) where

import Control.Monad.Fix (fix)
import System.IO
import Network.Socket
import Control.Concurrent

type Msg = (Int, String)


-- Sending a test message


processConnection :: (Socket, SockAddr) -> Chan Msg -> Int -> IO ()
processConnection (sock, _)  chan msgNum = do
  let broadcast msg = writeChan chan (msgNum, msg)
  hdl <- socketToHandle sock ReadWriteMode
  hSetBuffering hdl NoBuffering

  hPutStrLn hdl "Hi, enter name: "
  name <- fmap init (hGetLine hdl)
  broadcast ("::"  ++ name ++ "Entered chat")
  hPutStrLn hdl ("Welcome" ++ name ++ "!")

  commLine <- dupChan chan

  reader <- forkIO $ fix $ \loop -> do
    (nextNum, line) <- readChan commLine
    hPutStrLn hdl line
    loop

  fix $ \loop -> do
    line <- fmap init (hGetLine hdl)
    case line of
      "quit" -> hPutStrLn hdl "Bye!"
      _      -> broadcast line >> loop

  killThread reader
  hClose hdl
