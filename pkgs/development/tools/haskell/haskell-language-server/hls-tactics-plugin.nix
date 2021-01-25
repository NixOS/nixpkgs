{ mkDerivation, aeson, base, checkers, containers, deepseq
, directory, extra, fetchgit, filepath, fingertree, generic-lens
, ghc, ghc-boot-th, ghc-exactprint, ghc-source-gen, ghcide
, haskell-lsp, hie-bios, hls-plugin-api, hspec, hspec-discover
, lens, mtl, QuickCheck, refinery, retrie, shake, lib, syb, text
, transformers
}:
mkDerivation {
  pname = "hls-tactics-plugin";
  version = "0.5.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0p6fqs07lajbi2g1wf4w3j5lvwknnk58n12vlg48cs4iz25gp588";
    rev = "eb58f13f7b8e4f9bc771af30ff9fd82dc4309ff5";
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
  hydraPlatforms = lib.platforms.none;
}
