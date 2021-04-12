{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async-pool
, base, bower-json, bytestring, Cabal, containers, cryptonite
, dhall, directory, either, exceptions, extra, fetchgit, file-embed
, filepath, foldl, fsnotify, generic-lens, github, Glob, hpack
, hspec, hspec-discover, hspec-megaparsec, http-client
, http-conduit, http-types, lens-family-core, megaparsec, mtl
, network-uri, open-browser, optparse-applicative, prettyprinter
, process, QuickCheck, retry, rio, rio-orphans, safe, semver-range
, lib, stm, stringsearch, tar, template-haskell, temporary, text
, time, transformers, turtle, unliftio, unordered-containers
, utf8-string, vector, versions, with-utf8, zlib
}:
mkDerivation {
  pname = "spago";
  version = "0.20.0";
  src = fetchgit {
    url = "https://github.com/purescript/spago.git";
    sha256 = "1n48p9ycry8bjnf9jlcfgyxsbgn5985l4vhbwlv46kbb41ddwi51";
    rev = "7dfd2236aff92e5ae4f7a4dc336b50a7e14e4f44";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async-pool base bower-json
    bytestring Cabal containers cryptonite dhall directory either
    exceptions file-embed filepath foldl fsnotify generic-lens github
    Glob http-client http-conduit http-types lens-family-core
    megaparsec mtl network-uri open-browser optparse-applicative
    prettyprinter process retry rio rio-orphans safe semver-range stm
    stringsearch tar template-haskell temporary text time transformers
    turtle unliftio unordered-containers utf8-string vector versions
    with-utf8 zlib
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base text turtle with-utf8 ];
  testHaskellDepends = [
    base containers directory extra hspec hspec-megaparsec megaparsec
    process QuickCheck temporary text turtle versions
  ];
  testToolDepends = [ hspec-discover ];
  prePatch = "hpack";
  homepage = "https://github.com/purescript/spago#readme";
  license = lib.licenses.bsd3;
}
