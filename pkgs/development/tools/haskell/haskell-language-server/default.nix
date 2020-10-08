{ mkDerivation, aeson, base, binary, blaze-markup, brittany
, bytestring, containers, data-default, deepseq, Diff, directory
, extra, fetchgit, filepath, floskell, fourmolu, ghc, ghc-boot-th
, ghc-paths, ghcide, gitrev, hashable, haskell-lsp
, haskell-lsp-types, hie-bios, hslogger, hspec, hspec-core, lens
, lsp-test, optparse-applicative, optparse-simple, ormolu, process
, regex-tdfa, retrie, safe-exceptions, shake, stdenv, stm
, stylish-haskell, tasty, tasty-ant-xml, tasty-expected-failure
, tasty-golden, tasty-hunit, tasty-rerun, temporary, text, time
, transformers, unix, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.4.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "1fh9k9b3880m6ql4i10yn2yanskk9xhrakrrddqvainhcf2ik8hl";
    rev = "c4576992f443a9abe48ffcfa0e2d2b9bce15d7ae";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary brittany bytestring containers data-default
    deepseq Diff directory extra filepath floskell fourmolu ghc
    ghc-boot-th ghcide gitrev hashable haskell-lsp hie-bios hslogger
    lens optparse-simple ormolu process regex-tdfa retrie
    safe-exceptions shake stylish-haskell temporary text time
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
    hspec hspec-core lens lsp-test process stm tasty tasty-ant-xml
    tasty-expected-failure tasty-golden tasty-hunit tasty-rerun
    temporary text transformers unordered-containers yaml
  ];
  testToolDepends = [ ghcide ];
  homepage = "https://github.com/haskell/haskell-language-server#readme";
  description = "LSP server for GHC";
  license = stdenv.lib.licenses.asl20;
}
