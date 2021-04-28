{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async-pool
, base, bower-json, bytestring, Cabal, containers, cryptonite
, dhall, directory, either, extra, fetchgit, file-embed, filepath
, foldl, fsnotify, generic-lens, Glob, hpack, hspec, hspec-discover
, hspec-megaparsec, http-client, http-conduit, http-types
, lens-family-core, lib, megaparsec, mtl, network-uri, open-browser
, optparse-applicative, prettyprinter, process, QuickCheck, retry
, rio, rio-orphans, safe, semver-range, stm, stringsearch
, tar, template-haskell, temporary, text, time, transformers
, turtle, unliftio, unordered-containers, utf8-string, versions
, with-utf8, zlib
}:
mkDerivation {
  pname = "spago";
  version = "0.20.1";
  src = fetchgit {
    url = "https://github.com/purescript/spago.git";
    sha256 = "1j2yi6zz9m0k0298wllin39h244v8b2rx87yxxgdbjg77kn96vxg";
    rev = "41ad739614f4f2c2356ac921308f9475a5a918f4";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async-pool base bower-json
    bytestring Cabal containers cryptonite dhall directory either
    file-embed filepath foldl fsnotify generic-lens Glob http-client
    http-conduit http-types lens-family-core megaparsec mtl network-uri
    open-browser optparse-applicative prettyprinter process retry rio
    rio-orphans safe semver-range stm stringsearch tar template-haskell
    temporary text time transformers turtle unliftio
    unordered-containers utf8-string versions with-utf8 zlib
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    ansi-terminal base text turtle with-utf8
  ];
  testHaskellDepends = [
    base containers directory extra hspec hspec-megaparsec megaparsec
    process QuickCheck temporary text turtle versions
  ];
  testToolDepends = [ hspec-discover ];
  prePatch = "hpack";
  homepage = "https://github.com/purescript/spago#readme";
  license = lib.licenses.bsd3;
}
