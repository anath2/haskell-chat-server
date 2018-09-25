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
  hClose hdl
