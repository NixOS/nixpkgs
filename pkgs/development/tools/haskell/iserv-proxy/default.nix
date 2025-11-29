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
  version = "9.3-unstable-2025-06-21";

  # https://github.com/stable-haskell/iserv-proxy/pull/1
  src = fetchFromGitHub {
    owner = "stable-haskell";
    repo = "iserv-proxy";
    rev = "a53c57c9a8d22a66a2f0c4c969e806da03f08c28";
    hash = "sha256-WaswH0Y+Fmupvv8AkIlQBlUy/IdD3Inx9PDuE+5iRYY=";
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
