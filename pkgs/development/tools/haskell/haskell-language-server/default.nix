{ mkDerivation, aeson, base, binary, blaze-markup, brittany
, bytestring, containers, data-default, deepseq, directory, extra
, fetchgit, filepath, fingertree, floskell, fourmolu, ghc
, ghc-boot-th, ghc-exactprint, ghc-paths, ghc-source-gen, ghcide
, gitrev, hashable, haskell-lsp, hie-bios, hls-plugin-api, hslogger
, hspec, hspec-core, lens, lsp-test, mtl, optparse-applicative
, optparse-simple, ormolu, process, refinery, regex-tdfa, retrie
, safe-exceptions, shake, stdenv, stm, stylish-haskell, syb, tasty
, tasty-ant-xml, tasty-expected-failure, tasty-golden, tasty-hunit
, tasty-rerun, temporary, text, time, transformers
, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.5.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "1qi762fa72487i8fspxmr8xizm9n2s1shxsvnvsl67vj9if573r9";
    rev = "3ca2a6cd267f373aae19f59e1cf9e04b6524eff3";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers data-default directory extra filepath ghc ghcide
    gitrev haskell-lsp hie-bios hls-plugin-api hslogger
    optparse-applicative optparse-simple process text
    unordered-containers
  ];
  executableHaskellDepends = [
    aeson base binary brittany bytestring containers deepseq directory
    extra filepath fingertree floskell fourmolu ghc ghc-boot-th
    ghc-exactprint ghc-paths ghc-source-gen ghcide gitrev hashable
    haskell-lsp hie-bios hls-plugin-api hslogger lens mtl
    optparse-applicative optparse-simple ormolu process refinery
    regex-tdfa retrie safe-exceptions shake stylish-haskell syb
    temporary text time transformers unordered-containers
  ];
  testHaskellDepends = [
    aeson base blaze-markup bytestring containers data-default
    directory extra filepath haskell-lsp hie-bios hls-plugin-api
    hslogger hspec hspec-core lens lsp-test process stm tasty
    tasty-ant-xml tasty-expected-failure tasty-golden tasty-hunit
    tasty-rerun temporary text transformers unordered-containers yaml
  ];
  testToolDepends = [ ghcide ];
  homepage = "https://github.com/haskell/haskell-language-server#readme";
  description = "LSP server for GHC";
  license = stdenv.lib.licenses.asl20;
}
