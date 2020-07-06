{ mkDerivation, aeson, async, base, base16-bytestring, binary
, blaze-markup, brittany, bytestring, Cabal, cabal-helper
, containers, cryptohash-sha1, data-default, deepseq, Diff
, directory, extra, fetchgit, filepath, floskell, ghc, ghc-check
, ghc-paths, ghcide, gitrev, hashable, haskell-lsp
, haskell-lsp-types, hie-bios, hslogger, hspec, hspec-core
, hspec-expectations, lens, lsp-test, optparse-applicative
, optparse-simple, ormolu, process, regex-tdfa, safe-exceptions
, shake, stdenv, stm, stylish-haskell, tasty, tasty-ant-xml
, tasty-expected-failure, tasty-golden, tasty-hunit, tasty-rerun
, text, time, transformers, unix, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "092i32kc9dakl6cg1dpckrb87g4k8s4w1nvrs5x85n9ncgkpqk25";
    rev = "2a192db290bfe8640dafb6c1d650a0815e70d966";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary brittany bytestring Cabal cabal-helper containers
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
