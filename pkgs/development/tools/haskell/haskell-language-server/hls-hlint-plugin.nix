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
    sha256 = "0w37792wkq4ys7afgali4jg1kwgkbpk8q0y95fd2j1vgpk0pndlr";
    rev = "6a692de3308c06d8eb7bdf0f7b8a35b6e9a92610";
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
