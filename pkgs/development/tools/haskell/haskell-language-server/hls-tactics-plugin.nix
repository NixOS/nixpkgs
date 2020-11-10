{ mkDerivation, aeson, base, checkers, containers, deepseq
, directory, extra, fetchgit, filepath, fingertree, generic-lens
, ghc, ghc-boot-th, ghc-exactprint, ghc-source-gen, ghcide
, haskell-lsp, hie-bios, hls-plugin-api, hspec, lens, mtl
, QuickCheck, refinery, retrie, shake, stdenv, syb, text
, transformers
}:
mkDerivation {
  pname = "hls-tactics-plugin";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "1w15p988a5h11fcp25lllaj7j78f35gzg5bixy1vs7ld0p6jj7n9";
    rev = "8682517e9ff92caa35e727e28445896f97c61e8d";
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
  homepage = "https://github.com/isovector/hls-tactics-plugin#readme";
  description = "LSP server for GHC";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
