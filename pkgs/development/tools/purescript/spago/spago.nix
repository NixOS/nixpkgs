{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async-pool
, base, bower-json, bytestring, Cabal, containers, dhall, directory
, either, exceptions, extra, fetchgit, file-embed, filepath, foldl
, fsnotify, github, Glob, hpack, hspec, hspec-discover
, hspec-megaparsec, http-client, http-conduit, lens-family-core
, megaparsec, mtl, network-uri, open-browser, optparse-applicative
, prettyprinter, process, QuickCheck, retry, rio, rio-orphans, safe
, semver-range, stdenv, stm, tar, template-haskell, temporary, text
, time, transformers, turtle, unliftio, unordered-containers
, vector, versions, zlib
}:
mkDerivation {
  pname = "spago";
  version = "0.13.1";
  src = fetchgit {
    url = "https://github.com/spacchetti/spago.git";
    sha256 = "0l6sy1hz5dbnrjkvb2f44afhd48nwqx5kx1h29ns93xbbd57hci8";
    rev = "b87858609c671d8f3dc78f858ce1d8c492bd1062";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async-pool base bower-json
    bytestring Cabal containers dhall directory either exceptions
    file-embed filepath foldl fsnotify github Glob http-client
    http-conduit lens-family-core megaparsec mtl network-uri
    open-browser prettyprinter process retry rio rio-orphans safe
    semver-range stm tar template-haskell temporary text time
    transformers turtle unliftio unordered-containers vector versions
    zlib
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson-pretty async-pool base bytestring containers dhall filepath
    github lens-family-core megaparsec optparse-applicative process
    retry stm temporary text time turtle vector
  ];
  testHaskellDepends = [
    base containers directory extra hspec hspec-megaparsec megaparsec
    process QuickCheck temporary text turtle versions
  ];
  testToolDepends = [ hspec-discover ];
  prePatch = "hpack";
  homepage = "https://github.com/spacchetti/spago#readme";
  license = stdenv.lib.licenses.bsd3;
}
