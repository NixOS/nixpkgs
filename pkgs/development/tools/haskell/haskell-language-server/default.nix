{ mkDerivation, aeson, base, binary, blaze-markup, brittany
, bytestring, containers, data-default, deepseq, Diff, directory
, extra, fetchgit, filepath, floskell, ghc, ghc-paths, ghcide
, gitrev, hashable, haskell-lsp, haskell-lsp-types, hie-bios
, hslogger, hspec, hspec-core, hspec-expectations, lens, lsp-test
, optparse-applicative, optparse-simple, ormolu, process
, regex-tdfa, safe-exceptions, shake, stdenv, stm, stylish-haskell
, tasty, tasty-ant-xml, tasty-expected-failure, tasty-golden
, tasty-hunit, tasty-rerun, temporary, text, time, transformers
, unix, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.2.2.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0g9g2gyb0fidx16l741ky12djxh4cid9akvxa48105iq1gdihd8l";
    rev = "12c0e4423263140e3d16e76681927ec69fe4929f";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary brittany bytestring containers data-default
    deepseq Diff directory extra filepath floskell ghc ghcide gitrev
    hashable haskell-lsp hie-bios hslogger lens optparse-simple ormolu
    process regex-tdfa shake stylish-haskell temporary text time
    transformers unix unordered-containers
  ];
  executableHaskellDepends = [
    base binary containers data-default directory extra filepath ghc
    ghc-paths ghcide gitrev hashable haskell-lsp hie-bios hslogger
    optparse-applicative process safe-exceptions shake text time
    unordered-containers
  ];
  testHaskellDepends = [
    aeson base blaze-markup bytestring containers data-default
    directory filepath haskell-lsp haskell-lsp-types hie-bios hslogger
    hspec hspec-core hspec-expectations lens lsp-test process stm tasty
    tasty-ant-xml tasty-expected-failure tasty-golden tasty-hunit
    tasty-rerun temporary text transformers unordered-containers yaml
  ];
  testToolDepends = [ ghcide ];
  homepage = "https://github.com/haskell/haskell-language-server#readme";
  description = "LSP server for GHC";
  license = stdenv.lib.licenses.asl20;
}
