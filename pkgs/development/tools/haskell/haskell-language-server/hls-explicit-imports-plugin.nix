{ mkDerivation, aeson, base, containers, deepseq, fetchgit, ghc
, ghcide, haskell-lsp-types, hls-plugin-api, shake, stdenv, text
, unordered-containers
}:
mkDerivation {
  pname = "hls-explicit-imports-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0gkzvjx4dgf53yicinqjshlj80gznx5khb62i7g3kqjr85iy0raa";
    rev = "e4f677e1780fe85a02b99a09404a0a3c3ab5ce7c";
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
