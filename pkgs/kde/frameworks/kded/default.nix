{
  mkKdeDerivation,
  lib,
}:
mkKdeDerivation {
  pname = "kded";
  meta.mainProgram = "kded6";
  meta.badPlatforms = lib.platforms.darwin;
}
