{
  mkKdeDerivation,
  lib,
}:
mkKdeDerivation {
  pname = "kded";

  meta = {
    mainProgram = "kded6";
    badPlatforms = lib.platforms.darwin;
  };
}
