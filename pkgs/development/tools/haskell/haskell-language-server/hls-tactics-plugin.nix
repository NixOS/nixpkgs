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
    sha256 = "027fq6752024wzzq9izsilm5lkq9gmpxf82rixbimbijw0yk4pwj";
    rev = "372a12e797069dc3ac4fa33dcaabe3b992999d7c";
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
