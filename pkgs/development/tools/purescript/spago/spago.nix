{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async-pool
, base, bower-json, bytestring, Cabal, containers, dhall, directory
, either, exceptions, extra, fetchgit, file-embed, filepath, foldl
, fsnotify, generic-lens, github, Glob, hpack, hspec
, hspec-discover, hspec-megaparsec, http-client, http-conduit
, http-types, lens-family-core, megaparsec, mtl, network-uri
, open-browser, optparse-applicative, prettyprinter, process
, QuickCheck, retry, rio, rio-orphans, safe, semver-range, stdenv
, stm, stringsearch, tar, template-haskell, temporary, text, time
, transformers, turtle, unliftio, unordered-containers, utf8-string
, vector, versions, with-utf8, zlib
}:
mkDerivation {
  pname = "spago";
  version = "0.18.0";
  src = fetchgit {
    url = "https://github.com/purescript/spago.git";
    sha256 = "03ww7qhrggwsbm0kcnvcr3ifb8rm860ajimzr81isiw46ykwrl38";
    rev = "a4d39c21cae2f2c6d43fa204853c8e17c72904d2";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async-pool base bower-json
    bytestring Cabal containers dhall directory either exceptions
    file-embed filepath foldl fsnotify generic-lens github Glob
    http-client http-conduit http-types lens-family-core megaparsec mtl
    network-uri open-browser optparse-applicative prettyprinter process
    retry rio rio-orphans safe semver-range stm stringsearch tar
    template-haskell temporary text time transformers turtle unliftio
    unordered-containers utf8-string vector versions with-utf8 zlib
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
