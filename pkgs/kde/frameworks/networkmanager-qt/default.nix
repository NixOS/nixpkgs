{
  mkKdeDerivation,
  lib,
  qtdeclarative,
  pkg-config,
  networkmanager,
}:
mkKdeDerivation {
  pname = "networkmanager-qt";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [ networkmanager ];

  meta.badPlatforms = lib.platforms.darwin;
}
