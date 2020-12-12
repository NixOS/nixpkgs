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
    sha256 = "15hyscfllyapqinihmal6xkqwxgay7sgk5wqkjfgmlqsvl0vm7b7";
    rev = "9a742e2c6a31ff92a053735541e4cca9c2c18d3e";
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
