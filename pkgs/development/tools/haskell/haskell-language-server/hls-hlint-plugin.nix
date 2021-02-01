{ mkDerivation, aeson, apply-refact, base, binary, bytestring
, containers, data-default, deepseq, Diff, directory, extra
, fetchgit, filepath, ghc, ghc-exactprint, ghc-lib
, ghc-lib-parser-ex, ghcide, hashable, haskell-lsp, hlint
, hls-plugin-api, hslogger, lens, lib, regex-tdfa, shake, temporary
, text, transformers, unordered-containers
}:
mkDerivation {
  pname = "hls-hlint-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "18g0d7zac9xwywmp57dcrjnvms70f2mawviswskix78cv0iv4sk5";
    rev = "46d2a3dc7ef49ba57b2706022af1801149ab3f2b";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/hls-hlint-plugin; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson apply-refact base binary bytestring containers data-default
    deepseq Diff directory extra filepath ghc ghc-exactprint ghc-lib
    ghc-lib-parser-ex ghcide hashable haskell-lsp hlint hls-plugin-api
    hslogger lens regex-tdfa shake temporary text transformers
    unordered-containers
  ];
  description = "Hlint integration plugin with Haskell Language Server";
  license = lib.licenses.asl20;
}
