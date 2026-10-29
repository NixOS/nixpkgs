{
  mkDerivation,
  base,
  lib,
  # GHC source tree to build ghc-toolchain from
  ghcSrc,
  ghcVersion,
}:
mkDerivation {
  pname = "ghc-platform";
  version = ghcVersion;
  src = ghcSrc;
  postUnpack = ''
    sourceRoot="$sourceRoot/libraries/ghc-platform"
  '';
  libraryHaskellDepends = [ base ];
  description = "Platform information used by GHC and friends";
  license = lib.licenses.bsd3;
}
