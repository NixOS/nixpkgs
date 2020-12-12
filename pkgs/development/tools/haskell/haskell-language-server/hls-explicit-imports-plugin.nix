{ mkDerivation, aeson, base, containers, deepseq, fetchgit, ghc
, ghcide, haskell-lsp-types, hls-plugin-api, shake, stdenv, text
, unordered-containers
}:
mkDerivation {
  pname = "hls-explicit-imports-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "15hyscfllyapqinihmal6xkqwxgay7sgk5wqkjfgmlqsvl0vm7b7";
    rev = "9a742e2c6a31ff92a053735541e4cca9c2c18d3e";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-explicit-imports-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq ghc ghcide haskell-lsp-types
    hls-plugin-api shake text unordered-containers
  ];
  description = "Explicit imports plugin for Haskell Language Server";
  license = stdenv.lib.licenses.asl20;
}
