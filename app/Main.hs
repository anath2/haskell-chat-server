module Main where

import Server
import Network.Socket

main :: IO ()
main = do
  sock <- socket AF_INET Stream 0          -- Create a socket
  setSocketOption sock ReuseAddr 1         -- Allow address to be reused
  bind sock (SockAddrInet 5454 iNADDR_ANY) -- Bind to socket address listening on port 5454
  listen sock 2                            -- Maximum size of connection queue
  connectionLoop sock
