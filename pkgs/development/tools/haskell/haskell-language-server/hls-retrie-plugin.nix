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
    sha256 = "0w37792wkq4ys7afgali4jg1kwgkbpk8q0y95fd2j1vgpk0pndlr";
    rev = "6a692de3308c06d8eb7bdf0f7b8a35b6e9a92610";
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
