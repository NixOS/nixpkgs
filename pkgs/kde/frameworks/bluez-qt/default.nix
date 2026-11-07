{
  mkKdeDerivation,
  lib,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "bluez-qt";

  extraBuildInputs = [ qtdeclarative ];

  meta.badPlatforms = lib.platforms.darwin;
}
