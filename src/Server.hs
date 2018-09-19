module Sever
    (
      mainLoop,
      processConnection
    ) where


import Network.Socket


-- Main Loop

connectionLoop :: Socket -> IO ()
connectionLoop sock = do
  connection <- accept sock
  processConnecton connection
  connectionLoop sock


-- Sending a test message

procesConnection :: (Socket, SockAddr) -> IO ()
processConnection (sock, _) = do
  send sock "Testing\n"
  close sock
