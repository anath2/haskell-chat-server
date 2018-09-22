module Server
    (
      connectionLoop,
      processConnection
    ) where


import System.IO
import Network.Socket


-- Main Loop

connectionLoop :: Socket -> IO ()
connectionLoop sock = do
  connection <- accept sock
  processConnection connection
  connectionLoop sock


-- Sending a test message

processConnection :: (Socket, SockAddr) -> IO ()
processConnection (sock, _) = do
  hdl <- socketToHandle sock ReadWriteMode
  hSetBuffering hdl NoBuffering
  hPutStrLn hdl "hello"
  hClose hdl
