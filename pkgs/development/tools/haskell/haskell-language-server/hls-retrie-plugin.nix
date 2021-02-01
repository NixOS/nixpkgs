{ mkDerivation, aeson, base, containers, deepseq, directory, extra
, fetchgit, ghc, ghcide, hashable, haskell-lsp, haskell-lsp-types
, hls-plugin-api, lib, retrie, safe-exceptions, shake, text
, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-retrie-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-retrie-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq directory extra ghc ghcide hashable
    haskell-lsp haskell-lsp-types hls-plugin-api retrie safe-exceptions
    shake text transformers unordered-containers
  ];
  description = "Retrie integration plugin for Haskell Language Server";
  license = lib.licenses.asl20;
}
