{ mkDerivation, aeson, base, checkers, containers, deepseq
, directory, extra, fetchgit, filepath, fingertree, generic-lens
, ghc, ghc-boot-th, ghc-exactprint, ghc-source-gen, ghcide
, haskell-lsp, hie-bios, hls-plugin-api, hspec, hspec-discover
, lens, mtl, QuickCheck, refinery, retrie, shake, stdenv, syb, text
, transformers
}:
mkDerivation {
  pname = "hls-tactics-plugin";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0w37792wkq4ys7afgali4jg1kwgkbpk8q0y95fd2j1vgpk0pndlr";
    rev = "6a692de3308c06d8eb7bdf0f7b8a35b6e9a92610";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/tactics; echo source root reset to $sourceRoot";
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
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
