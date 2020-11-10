{ mkDerivation, aeson, apply-refact, base, binary, bytestring
, containers, data-default, deepseq, Diff, directory, extra
, fetchgit, filepath, ghc, ghc-lib, ghc-lib-parser-ex, ghcide
, hashable, haskell-lsp, hlint, hls-plugin-api, hslogger, lens
, regex-tdfa, shake, stdenv, temporary, text, transformers
, unordered-containers
}:
mkDerivation {
  pname = "hls-hlint-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "1w15p988a5h11fcp25lllaj7j78f35gzg5bixy1vs7ld0p6jj7n9";
    rev = "8682517e9ff92caa35e727e28445896f97c61e8d";
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
  license = stdenv.lib.licenses.asl20;
}
