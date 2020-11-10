{ mkDerivation, aeson, array, async, base, base16-bytestring
, binary, bytestring, Chart, Chart-diagrams, containers
, cryptohash-sha1, data-default, deepseq, diagrams, diagrams-svg
, directory, extra, fetchgit, filepath, fingertree, fuzzy, ghc
, ghc-boot, ghc-boot-th, ghc-check, ghc-paths
, ghc-typelits-knownnat, gitrev, Glob, haddock-library, hashable
, haskell-lsp, haskell-lsp-types, hie-bios, hslogger
, implicit-hie-cradle, lens, lsp-test, mtl, network-uri
, optparse-applicative, prettyprinter, prettyprinter-ansi-terminal
, process, QuickCheck, quickcheck-instances
, record-dot-preprocessor, record-hasfield, regex-tdfa
, rope-utf16-splay, safe, safe-exceptions, shake, sorted-list
, stdenv, stm, syb, tasty, tasty-expected-failure, tasty-hunit
, tasty-quickcheck, tasty-rerun, text, time, transformers, unix
, unordered-containers, utf8-string, yaml
}:
mkDerivation {
  pname = "ghcide";
  version = "0.4.0";
  src = fetchgit {
    url = "https://github.com/haskell/ghcide";
    sha256 = "0zv14mvfhmwwkhyzkr38qpvyffa8ywzp41lr1k55pbrc5b10fjr6";
    rev = "0bfce3114c28bd00f7bf5729c32ec0f23a8d8854";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson array async base base16-bytestring binary bytestring
    containers cryptohash-sha1 data-default deepseq directory extra
    filepath fingertree fuzzy ghc ghc-boot ghc-boot-th ghc-check
    ghc-paths Glob haddock-library hashable haskell-lsp
    haskell-lsp-types hie-bios hslogger implicit-hie-cradle mtl
    network-uri prettyprinter prettyprinter-ansi-terminal regex-tdfa
    rope-utf16-splay safe safe-exceptions shake sorted-list stm syb
    text time transformers unix unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    aeson base bytestring containers data-default directory extra
    filepath gitrev hashable haskell-lsp haskell-lsp-types hie-bios
    lens lsp-test optparse-applicative process safe-exceptions text
    unordered-containers
  ];
  testHaskellDepends = [
    aeson base binary bytestring containers directory extra filepath
    ghc ghc-typelits-knownnat haddock-library haskell-lsp
    haskell-lsp-types lens lsp-test network-uri optparse-applicative
    process QuickCheck quickcheck-instances record-dot-preprocessor
    record-hasfield rope-utf16-splay safe safe-exceptions shake tasty
    tasty-expected-failure tasty-hunit tasty-quickcheck tasty-rerun
    text
  ];
  benchmarkHaskellDepends = [
    aeson base Chart Chart-diagrams diagrams diagrams-svg directory
    extra filepath shake text yaml
  ];
  homepage = "https://github.com/haskell/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
