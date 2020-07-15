{ mkDerivation, aeson, async, base, base16-bytestring, binary
, blaze-markup, brittany, bytestring, cabal-helper, containers
, cryptohash-sha1, data-default, deepseq, Diff, directory, extra
, fetchgit, filepath, floskell, ghc, ghc-check, ghc-paths, ghcide
, gitrev, hashable, haskell-lsp, haskell-lsp-types, hie-bios
, hslogger, hspec, hspec-core, hspec-expectations, lens, lsp-test
, optparse-applicative, optparse-simple, ormolu, process
, regex-tdfa, safe-exceptions, shake, stdenv, stm, stylish-haskell
, tasty, tasty-ant-xml, tasty-expected-failure, tasty-golden
, tasty-hunit, tasty-rerun, text, time, transformers, unix
, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0nkfyb0zg57jwr2gry0f3fycvqvb4rkayx42m841dgd4phyvrfrq";
    rev = "35205ee3f95a8fbb4ef9a4ae4d9d82ac3d36d3f0";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary brittany bytestring cabal-helper containers
    data-default deepseq Diff directory extra filepath floskell ghc
    ghcide gitrev hashable haskell-lsp hie-bios hslogger lens
    optparse-simple ormolu process regex-tdfa shake stylish-haskell
    text transformers unix unordered-containers
  ];
  executableHaskellDepends = [
    aeson async base base16-bytestring binary bytestring containers
    cryptohash-sha1 data-default deepseq directory extra filepath ghc
    ghc-check ghc-paths ghcide gitrev hashable haskell-lsp hie-bios
    hslogger optparse-applicative process safe-exceptions shake text
    time unordered-containers
  ];
  testHaskellDepends = [
    aeson base blaze-markup bytestring containers data-default
    directory filepath haskell-lsp haskell-lsp-types hie-bios hslogger
    hspec hspec-core hspec-expectations lens lsp-test stm tasty
    tasty-ant-xml tasty-expected-failure tasty-golden tasty-hunit
    tasty-rerun text unordered-containers yaml
  ];
  testToolDepends = [ ghcide ];
  homepage = "https://github.com/haskell/haskell-language-server#readme";
  description = "LSP server for GHC";
  license = stdenv.lib.licenses.asl20;
}
