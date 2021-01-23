{ mkDerivation, aeson, apply-refact, base, binary, bytestring
, containers, data-default, deepseq, Diff, directory, extra
, fetchgit, filepath, ghc, ghc-lib, ghc-lib-parser-ex, ghcide
, hashable, haskell-lsp, hlint, hls-plugin-api, hslogger, lens
, regex-tdfa, shake, lib, stdenv, temporary, text, transformers
, unordered-containers
}:
mkDerivation {
  pname = "hls-hlint-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0p6fqs07lajbi2g1wf4w3j5lvwknnk58n12vlg48cs4iz25gp588";
    rev = "eb58f13f7b8e4f9bc771af30ff9fd82dc4309ff5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-hlint-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson apply-refact base binary bytestring containers data-default
    deepseq Diff directory extra filepath ghc ghc-lib ghc-lib-parser-ex
    ghcide hashable haskell-lsp hlint hls-plugin-api hslogger lens
    regex-tdfa shake temporary text transformers unordered-containers
  ];
  description = "Hlint integration plugin with Haskell Language Server";
  license = lib.licenses.asl20;
}
