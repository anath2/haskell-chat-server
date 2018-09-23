module Server
  (
    processConnection
  ) where


import System.IO
import Network.Socket
import Network.Concurrent

type Msg = String


-- Sending a test message


processConnection :: (Socket, SockAddr) -> Chan Msg -> IO ()
processConnection (sock, _) = do
  hdl <- socketToHandle sock ReadWriteMode
  hSetBuffering hdl NoBuffering
  hPutStrLn hdl "hello"
  hClose hdl
