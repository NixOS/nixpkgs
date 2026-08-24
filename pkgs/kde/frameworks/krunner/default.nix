{
  mkKdeDerivation,
  lib,
  plasma-activities,
}:
mkKdeDerivation {
  pname = "krunner";

  extraBuildInputs = [ plasma-activities ];

  meta.badPlatforms = lib.platforms.darwin;
}
