{ mkDerivation, aeson, base, containers, deepseq, fetchgit, ghc
, ghcide, haskell-lsp-types, hls-plugin-api, lib, shake, text
, unordered-containers
}:
mkDerivation {
  pname = "hls-explicit-imports-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-explicit-imports-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq ghc ghcide haskell-lsp-types
    hls-plugin-api shake text unordered-containers
  ];
  description = "Explicit imports plugin for Haskell Language Server";
  license = lib.licenses.asl20;
}
