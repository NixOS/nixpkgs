{ mkDerivation, aeson, base, containers, deepseq, Diff, directory
, extra, fetchgit, filepath, ghc, ghc-boot-th, ghc-paths, ghcide
, hashable, haskell-lsp, haskell-lsp-types, hls-plugin-api
, parser-combinators, pretty-simple, QuickCheck, safe-exceptions
, shake, lib, stdenv, temporary, text, time, transformers
, unordered-containers
}:
mkDerivation {
  pname = "hls-eval-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0p6fqs07lajbi2g1wf4w3j5lvwknnk58n12vlg48cs4iz25gp588";
    rev = "eb58f13f7b8e4f9bc771af30ff9fd82dc4309ff5";
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
