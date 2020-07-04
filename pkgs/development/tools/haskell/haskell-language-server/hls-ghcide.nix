{ mkDerivation, aeson, array, async, base, base16-bytestring
, binary, bytestring, Chart, Chart-diagrams, containers
, cryptohash-sha1, data-default, deepseq, diagrams, diagrams-svg
, directory, extra, fetchgit, filepath, fuzzy, ghc, ghc-boot
, ghc-boot-th, ghc-check, ghc-paths, ghc-typelits-knownnat, gitrev
, haddock-library, hashable, haskell-lsp, haskell-lsp-types
, hie-bios, hslogger, lens, lsp-test, mtl, network-uri
, opentelemetry, optparse-applicative, parser-combinators
, prettyprinter, prettyprinter-ansi-terminal, process, QuickCheck
, quickcheck-instances, regex-tdfa, rope-utf16-splay
, safe-exceptions, shake, sorted-list, stdenv, stm, syb, tasty
, tasty-expected-failure, tasty-hunit, tasty-quickcheck
, tasty-rerun, text, time, transformers, unix, unordered-containers
, utf8-string, yaml
}:
mkDerivation {
  pname = "ghcide";
  version = "0.2.0";
  src = fetchgit {
    url = "https://github.com/wz1000/ghcide";
    sha256 = "0rifbrfvbgv7szgwc5apzb0i5fbkr2spzqvwg5kzng5b4zrf9a9d";
    rev = "cc09b6d4cf03efa645c682347c62850c2291be25";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson array async base binary bytestring containers data-default
    deepseq directory extra filepath fuzzy ghc ghc-boot ghc-boot-th
    haddock-library hashable haskell-lsp haskell-lsp-types hslogger mtl
    network-uri opentelemetry prettyprinter prettyprinter-ansi-terminal
    regex-tdfa rope-utf16-splay safe-exceptions shake sorted-list stm
    syb text time transformers unix unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    aeson async base base16-bytestring binary bytestring containers
    cryptohash-sha1 data-default deepseq directory extra filepath ghc
    ghc-check ghc-paths gitrev hashable haskell-lsp haskell-lsp-types
    hie-bios hslogger optparse-applicative safe-exceptions shake text
    time unordered-containers
  ];
  testHaskellDepends = [
    aeson base bytestring containers directory extra filepath ghc
    ghc-typelits-knownnat haddock-library haskell-lsp haskell-lsp-types
    lens lsp-test network-uri optparse-applicative parser-combinators
    process QuickCheck quickcheck-instances rope-utf16-splay
    safe-exceptions shake tasty tasty-expected-failure tasty-hunit
    tasty-quickcheck tasty-rerun text
  ];
  benchmarkHaskellDepends = [
    aeson base bytestring Chart Chart-diagrams containers diagrams
    diagrams-svg directory extra filepath lsp-test optparse-applicative
    parser-combinators process safe-exceptions shake text yaml
  ];
  homepage = "https://github.com/digital-asset/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
