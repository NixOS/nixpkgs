{ mkDerivation, aeson, base, containers, data-default, Diff
, fetchgit, hashable, haskell-lsp, hslogger, lens, lib, process
, regex-tdfa, shake, text, unix, unordered-containers
}:
mkDerivation {
  pname = "hls-plugin-api";
  version = "0.6.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server.git";
    sha256 = "0i17ssfmcgh6z1b8q7cy3x46xi81x5z82ngik86h8d5cb6w98lsn";
    rev = "9c40dcff1b989b14e05b5aebe96f3da78c6ea25c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/hls-plugin-api; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers data-default Diff hashable haskell-lsp
    hslogger lens process regex-tdfa shake text unix
    unordered-containers
  ];
  homepage = "https://github.com/haskell/haskell-language-server/hls-plugin-api";
  description = "Haskell Language Server API for plugin communication";
  license = lib.licenses.asl20;
}
