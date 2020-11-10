{ mkDerivation, aeson, base, binary, blaze-markup, brittany
, bytestring, containers, data-default, deepseq, directory, extra
, fetchgit, filepath, floskell, fourmolu, ghc, ghc-boot-th
, ghc-paths, ghcide, gitrev, hashable, haskell-lsp, hie-bios
, hls-hlint-plugin, hls-plugin-api, hls-tactics-plugin, hslogger
, hspec, hspec-core, lens, lsp-test, mtl, optparse-applicative
, optparse-simple, ormolu, process, regex-tdfa, retrie
, safe-exceptions, shake, stdenv, stm, stylish-haskell, tasty
, tasty-ant-xml, tasty-expected-failure, tasty-golden, tasty-hunit
, tasty-rerun, temporary, text, time, transformers
, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "1w15p988a5h11fcp25lllaj7j78f35gzg5bixy1vs7ld0p6jj7n9";
    rev = "8682517e9ff92caa35e727e28445896f97c61e8d";
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
    extra filepath floskell fourmolu ghc ghc-boot-th ghc-paths ghcide
    gitrev hashable haskell-lsp hie-bios hls-hlint-plugin
    hls-plugin-api hls-tactics-plugin hslogger lens mtl
    optparse-applicative optparse-simple ormolu process regex-tdfa
    retrie safe-exceptions shake stylish-haskell temporary text time
    transformers unordered-containers
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
