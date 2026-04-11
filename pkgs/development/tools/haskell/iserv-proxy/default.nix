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
  version = "9.3-unstable-2025-10-30";

  # https://github.com/stable-haskell/iserv-proxy/pull/1
  src = fetchFromGitHub {
    owner = "stable-haskell";
    repo = "iserv-proxy";
    rev = "bbee090fc67bb5cc6ad4508fa5def560b7672591";
    hash = "sha256-2aCGboNCF602huvmbyTcfhe6s+D4/n/NlOefd0c0SC0=";
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
