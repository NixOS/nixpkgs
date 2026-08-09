{
  mkKdeDerivation,
  lib,
  qttools,
}:
mkKdeDerivation {
  pname = "kglobalaccel";

  extraNativeBuildInputs = [ qttools ];

  meta.badPlatforms = lib.platforms.darwin;
}
