module Server
  (
    processConnection
  ) where

import Control.Monad.Fix (fix)
import System.IO
import Network.Socket
import Control.Concurrent

type Msg = String


-- Sending a test message


processConnection :: (Socket, SockAddr) -> Chan Msg -> IO ()
processConnection (sock, _)  chan = do
  let broadcast msg = writeChan chan msg
  hdl <- socketToHandle sock ReadWriteMode
  hSetBuffering hdl NoBuffering
  hPutStrLn hdl "hello"
  commLine <- dupChan chan

  reader <- forkIO $ fix $ \loop -> do
    line <- readChan commLine
    hPutStrLn hdl line
    loop

  fix $ \loop -> do
    line <- fmap init (hGetLine hdl)
    case line of
      "quit" -> hPutStrLn hdl "Bye!"
      _      -> broadcast line >> loop

  killThread reader
  hClose hdl
