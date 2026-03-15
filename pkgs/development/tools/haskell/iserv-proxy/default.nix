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
  version = "9.3-unstable-2026-02-04";

  # https://github.com/stable-haskell/iserv-proxy/pull/1
  src = fetchFromGitHub {
    owner = "stable-haskell";
    repo = "iserv-proxy";
    rev = "91ef7ffdeedfb141a4d69dcf9e550abe3e1160c6";
    hash = "sha256-x6QYupvHZM7rRpVO4AIC5gUWFprFQ59A95FPC7/Owjg";
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
