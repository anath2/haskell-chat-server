module Server
  (
    processConnection
  ) where

import System.IO
import Network.Socket

import Control.Concurrent
import Control.Exception
import Control.Monad.Fix (fix)
import Control.Monad (when)

type Msg = (Int, String)


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
    when (msgNum /= nextNum) $ hPutStrLn hdl line
    loop

  handle (\(SomeException _) -> return ()) $ fix $ \loop -> do
    line <- fmap init (hGetLine hdl)
    case line of
      "quit" -> hPutStrLn hdl "Bye!"
      _      -> broadcast line >> loop

  killThread reader
  hClose hdl
