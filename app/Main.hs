module Main where

import Server
import Network.Socket
import Control.Concurrent


type Msg = String


main :: IO ()
main = do
  sock <- socket AF_INET Stream 0          -- Create a socket
  setSocketOption sock ReuseAddr 1         -- Allow address to be reused
  bind sock (SockAddrInet 5454 iNADDR_ANY) -- Bind to socket address listening on port 5454
  listen sock 2                            -- Maximum size of connection queue
  chan <- newChan
  connectionLoop sock chan


-- Main connection loop

connectionLoop :: Socket -> Chan Msg -> IO ()
connectionLoop sock chan  = do
  connection <- accept sock
  forkIO (processConnection connection chan)  -- Split off each operation into it's own thread
  connectionLoop sock chan
