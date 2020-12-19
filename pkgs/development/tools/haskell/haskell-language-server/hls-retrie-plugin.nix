{ mkDerivation, aeson, base, containers, deepseq, directory, extra
, fetchgit, ghc, ghcide, hashable, haskell-lsp, haskell-lsp-types
, hls-plugin-api, retrie, safe-exceptions, shake, stdenv, text
, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-retrie-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0gkzvjx4dgf53yicinqjshlj80gznx5khb62i7g3kqjr85iy0raa";
    rev = "e4f677e1780fe85a02b99a09404a0a3c3ab5ce7c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-retrie-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq directory extra ghc ghcide hashable
    haskell-lsp haskell-lsp-types hls-plugin-api retrie safe-exceptions
    shake text transformers unordered-containers
  ];
  description = "Retrie integration plugin for Haskell Language Server";
  license = stdenv.lib.licenses.asl20;
}
