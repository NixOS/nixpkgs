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
    sha256 = "027fq6752024wzzq9izsilm5lkq9gmpxf82rixbimbijw0yk4pwj";
    rev = "372a12e797069dc3ac4fa33dcaabe3b992999d7c";
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
