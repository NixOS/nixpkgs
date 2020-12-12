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
    sha256 = "15hyscfllyapqinihmal6xkqwxgay7sgk5wqkjfgmlqsvl0vm7b7";
    rev = "9a742e2c6a31ff92a053735541e4cca9c2c18d3e";
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
  homepage = "https://github.com/isovector/hls-tactics-plugin#readme";
  description = "LSP server for GHC";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
