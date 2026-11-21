{
  mkKdeDerivation,
  lib,
  pkg-config,
  packagekit-qt,
}:
mkKdeDerivation {
  pname = "frameworkintegration";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ packagekit-qt ];

  meta.badPlatforms = lib.platforms.darwin;
}
