{ mkDerivation, aeson, base, containers, fetchgit, ghc
, ghc-exactprint, ghcide, haskell-lsp, hls-plugin-api, lens, shake
, stdenv, text, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-class-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0p6fqs07lajbi2g1wf4w3j5lvwknnk58n12vlg48cs4iz25gp588";
    rev = "eb58f13f7b8e4f9bc771af30ff9fd82dc4309ff5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-class-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers ghc ghc-exactprint ghcide haskell-lsp
    hls-plugin-api lens shake text transformers unordered-containers
  ];
  description = "Explicit imports plugin for Haskell Language Server";
  license = stdenv.lib.licenses.asl20;
}
