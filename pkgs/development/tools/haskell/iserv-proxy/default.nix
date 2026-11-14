{
  mkDerivation,
  fetchFromGitHub,
  array,
  base,
  binary,
  bytestring,
  containers,
  deepseq,
  directory,
  filepath,
  ghci,
  lib,
  network,
}:
mkDerivation {
  pname = "iserv-proxy";
  version = "9.3-unstable-2026-04-08";

  # https://github.com/stable-haskell/iserv-proxy/pull/1
  src = fetchFromGitHub {
    owner = "stable-haskell";
    repo = "iserv-proxy";
    rev = "3f7b2815307c20a0dfd816bdf4a39ab86af3e0d4";
    hash = "sha256-10x8/G0x3eR/++XRHPx4MBuqlnc6+N+ajIxXyLkG+nU=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array
    base
    binary
    bytestring
    containers
    deepseq
    directory
    filepath
    ghci
    network
  ];
  executableHaskellDepends = [
    base
    binary
    bytestring
    directory
    filepath
    ghci
    network
  ];
  description = "iserv allows GHC to delegate Template Haskell computations";
  license = lib.licenses.bsd3;
}
