{
  mkDerivation,
  base,
  directory,
  filepath,
  ghc-platform,
  lib,
  process,
  text,
  transformers,
  # GHC source tree to build ghc-toolchain from
  ghcVersion,
  ghcSrc,
}:
mkDerivation {
  pname = "ghc-toolchain";
  version = ghcVersion;
  src = ghcSrc;
  postUnpack = ''
    sourceRoot="$sourceRoot/utils/ghc-toolchain"
  '';
  libraryHaskellDepends = [
    base
    directory
    filepath
    ghc-platform
    process
    text
    transformers
  ];
  description = "Utility for managing GHC target toolchains";
  license = lib.licenses.bsd3;
}
