{ mkDerivation, aeson, base, binary, blaze-markup, brittany
, bytestring, containers, data-default, deepseq, directory, extra
, fetchgit, filepath, floskell, fourmolu, ghc, ghc-boot-th
, ghc-paths, ghcide, gitrev, hashable, haskell-lsp, hie-bios
, hls-explicit-imports-plugin, hls-hlint-plugin, hls-plugin-api
, hls-retrie-plugin, hls-tactics-plugin, hslogger, hspec
, hspec-core, lens, lsp-test, mtl, optparse-applicative
, optparse-simple, ormolu, process, regex-tdfa, safe-exceptions
, shake, stdenv, stm, stylish-haskell, tasty, tasty-ant-xml
, tasty-expected-failure, tasty-golden, tasty-hunit, tasty-rerun
, temporary, text, time, transformers, unordered-containers, yaml
}:
mkDerivation {
  pname = "haskell-language-server";
  version = "0.7.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0w37792wkq4ys7afgali4jg1kwgkbpk8q0y95fd2j1vgpk0pndlr";
    rev = "6a692de3308c06d8eb7bdf0f7b8a35b6e9a92610";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers data-default directory extra filepath ghc ghcide
    gitrev haskell-lsp hls-plugin-api hslogger optparse-applicative
    optparse-simple process text unordered-containers
  ];
  executableHaskellDepends = [
    aeson base binary brittany bytestring containers deepseq directory
    extra filepath floskell fourmolu ghc ghc-boot-th ghc-paths ghcide
    gitrev hashable haskell-lsp hie-bios hls-explicit-imports-plugin
    hls-hlint-plugin hls-plugin-api hls-retrie-plugin
    hls-tactics-plugin hslogger lens mtl optparse-applicative
    optparse-simple ormolu process regex-tdfa safe-exceptions shake
    stylish-haskell temporary text time transformers
    unordered-containers
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
