{
  mkKdeDerivation,
  lib,
  pkg-config,
  modemmanager,
}:
mkKdeDerivation {
  pname = "modemmanager-qt";

  extraNativeBuildInputs = [ pkg-config ];
  extraPropagatedBuildInputs = [ modemmanager ];

  meta.badPlatforms = lib.platforms.darwin;
}
