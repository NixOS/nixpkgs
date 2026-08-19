ghc-settings-edit is a small tool for changing certain fields in the settings
file that is part of every GHC installation (usually located at
lib/ghc-$version/lib/settings or lib/ghc-$version/settings). This is sometimes
necessary because GHC's build process leaks the tools used at build time into
the final settings file. This is fine, as long as the build and host platform
of the GHC build is the same since it will be possible to execute the tools
used at build time at run time. In case we are cross compiling GHC itself,
the settings file needs to be changed so that the correct tools are used in the
final installation. The GHC build system itself doesn't allow for this due to
its somewhat peculiar bootstrapping mechanism.

This tool was originally written by sternenseemann and is licensed under the MIT
license (as is nixpkgs) as well as the BSD 3 Clause license since it incorporates
some code from GHC. It is primarily intended for use in nixpkgs, so it should be
considered unstable: No guarantees about the stability of its command line
interface are made at this time.

> -- SPDX-License-Identifier: MIT AND BSD-3-Clause
> {-# LANGUAGE LambdaCase #-}
> module Main where

ghc-settings-edit requires no additional dependencies to the ones already
required to bootstrap GHC. This means that it only depends on GHC and core
libraries shipped with the compiler (base and containers). This property should
be preserved going forward as to not needlessly complicate bootstrapping GHC
in nixpkgs. Additionally, a wide range of library versions and thus GHC versions
should be supported (via CPP if necessary).

> import Control.Monad (foldM)
> import qualified Data.Map.Lazy as Map
> import System.Environment (getArgs, getProgName)
> import Text.Read (readEither)

Note that the containers dependency is needed to represent the contents of the
settings file. In theory, [(String, String)] (think lookup) would suffice, but
base doesn't provide any facilities for updating such lists. To avoid needlessly
reinventing the wheel here, we depend on an extra core library.

> type SettingsMap = Map.Map String String

ghc-settings-edit accepts the following arguments:

- The path to the settings file which is edited in place.
- For every field in the settings file to be updated, two arguments need to be
  passed: the name of the field and its new value. Any number of these pairs
  may be provided. If a field is missing from the given settings file,
  it won't be added (see also below).

> usage :: String -> String
> usage name = "Usage: " ++ name ++ " FILE [KEY NEWVAL [KEY2 NEWVAL2 ...]]"

The arguments and the contents of the settings file are fed into the performEdits
function which implements the main logic of ghc-settings-edit (except IO).

> performEdits :: [String] -> String -> Either String String
> performEdits editArgs settingsString = do

First, the settings file is parsed and read into the SettingsMap structure. For
parsing, we can simply rely read, as GHC uses the familiar Read/Show format
(plus some formatting) for storing its settings. This is the main reason
ghc-settings-edit is written in Haskell: We don't need to roll our own parser.

>   settingsMap <- Map.fromList <$> readEither settingsString

We also need to parse the remaining command line arguments (after the path)
which means splitting them into pairs of arguments describing the individual
edits. We use the chunkList utility function from GHC for this which is vendored
below. Since it doesn't guarantee that all sublists have the exact length given,
we'll have to check the length of the returned “pairs” later.

>   let edits = chunkList 2 editArgs

Since each edit is a transformation of the SettingsMap, we use a fold to go
through the edits. The Either monad allows us to bail out if one is malformed.
The use of Map.adjust ensures that fields that aren't present in the original
settings file aren't added since the corresponding GHC installation wouldn't
understand them. Note that this is done silently which may be suboptimal:
It could be better to fail.

>   show . Map.toList <$> foldM applyEdit settingsMap edits
>   where
>     applyEdit :: SettingsMap -> [String] -> Either String SettingsMap
>     applyEdit m [key, newValue] = Right $ Map.adjust (const newValue) key m
>     applyEdit _ _ = Left "Uneven number of edit arguments provided"

main just wraps performEdits and takes care of reading from and writing to the
given file.

> main :: IO ()
> main =
>   getArgs >>= \case
>     (settingsFile:edits) -> do
>       orig <- readFile settingsFile
>       case performEdits edits orig of
>         Right edited -> writeFile settingsFile edited
>         Left errorMsg -> error errorMsg
>     _ -> do
>            name <- getProgName
>            error $ usage name

As mentioned, chunkList is taken from GHC, specifically GHC.Utils.Misc of GHC
verson 9.8.2. We don't depend on the ghc library directly (which would be
possible in theory) since there are no stability guarantees or deprecation
windows for the ghc's public library.

> -- | Split a list into chunks of /n/ elements
> chunkList :: Int -> [a] -> [[a]]
> chunkList _ [] = []
> chunkList n xs = as : chunkList n bs where (as,bs) = splitAt n xs
