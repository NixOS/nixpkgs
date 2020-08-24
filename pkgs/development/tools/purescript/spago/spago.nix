{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async-pool
, base, bower-json, bytestring, Cabal, containers, dhall, directory
, either, exceptions, extra, fetchgit, file-embed, filepath, foldl
, fsnotify, github, Glob, hpack, hspec, hspec-discover
, hspec-megaparsec, http-client, http-conduit, lens-family-core
, megaparsec, mtl, network-uri, open-browser, optparse-applicative
, prettyprinter, process, QuickCheck, retry, rio, rio-orphans, safe
, semver-range, stdenv, stm, tar, template-haskell, temporary, text
, time, transformers, turtle, unliftio, unordered-containers
, vector, versions, with-utf8, zlib
}:
mkDerivation {
  pname = "spago";
  version = "0.16.0";
  src = fetchgit {
    url = "https://github.com/purescript/spago.git";
    sha256 = "0z4s0z14n1v9wajs7mj2b295rrrw24gdca79drzlv6x1y6dj7sxh";
    rev = "71b093cdf5e48ded645303281ab4a3ea5b730f5d";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async-pool base bower-json
    bytestring Cabal containers dhall directory either exceptions
    file-embed filepath foldl fsnotify github Glob http-client
    http-conduit lens-family-core megaparsec mtl network-uri
    open-browser optparse-applicative prettyprinter process retry rio
    rio-orphans safe semver-range stm tar template-haskell temporary
    text time transformers turtle unliftio unordered-containers vector
    versions with-utf8 zlib
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
  license = stdenv.lib.licenses.bsd3;
}
