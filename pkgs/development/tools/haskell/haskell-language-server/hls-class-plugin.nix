{ mkDerivation, aeson, base, containers, fetchgit, ghc
, ghc-exactprint, ghcide, haskell-lsp, hls-plugin-api, lens, lib
, shake, text, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-class-plugin";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-class-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers ghc ghc-exactprint ghcide haskell-lsp
    hls-plugin-api lens shake text transformers unordered-containers
  ];
  homepage = "https://github.com/haskell/haskell-language-server#readme";
  description = "Class/instance management plugin for Haskell Language Server";
  license = lib.licenses.asl20;
}
