{ mkDerivation, aeson, base, checkers, containers, deepseq
, directory, extra, fetchgit, filepath, fingertree, generic-lens
, ghc, ghc-boot-th, ghc-exactprint, ghc-source-gen, ghcide
, haskell-lsp, hie-bios, hls-plugin-api, hspec, hspec-discover
, lens, lib, mtl, QuickCheck, refinery, retrie, shake, syb, text
, transformers
}:
mkDerivation {
  pname = "hls-tactics-plugin";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-tactics-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq directory extra filepath fingertree
    generic-lens ghc ghc-boot-th ghc-exactprint ghc-source-gen ghcide
    haskell-lsp hls-plugin-api lens mtl refinery retrie shake syb text
    transformers
  ];
  testHaskellDepends = [
    base checkers containers ghc hie-bios hls-plugin-api hspec mtl
    QuickCheck
  ];
  testToolDepends = [ hspec-discover ];
  description = "Tactics plugin for Haskell Language Server";
  license = lib.licenses.asl20;
}
