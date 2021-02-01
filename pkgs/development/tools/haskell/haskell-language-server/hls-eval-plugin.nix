{ mkDerivation, aeson, base, containers, deepseq, Diff, directory
, extra, fetchgit, filepath, ghc, ghc-boot-th, ghc-paths, ghcide
, hashable, haskell-lsp, haskell-lsp-types, hls-plugin-api, lib
, parser-combinators, pretty-simple, QuickCheck, safe-exceptions
, shake, temporary, text, time, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-eval-plugin";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-eval-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers deepseq Diff directory extra filepath ghc
    ghc-boot-th ghc-paths ghcide hashable haskell-lsp haskell-lsp-types
    hls-plugin-api parser-combinators pretty-simple QuickCheck
    safe-exceptions shake temporary text time transformers
    unordered-containers
  ];
  description = "Eval plugin for Haskell Language Server";
  license = lib.licenses.asl20;
}
