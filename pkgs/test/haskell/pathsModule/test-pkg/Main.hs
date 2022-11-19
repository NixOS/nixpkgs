module Main where

import Paths_pathsModule

main :: IO ()
main = getBinDir >>= putStrLn
