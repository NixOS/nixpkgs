{
  lib,
  mkKdeDerivation,
  extra-cmake-modules,
}:
mkKdeDerivation {
  pname = "plasma-workspace-wallpapers";
  extraBuildInputs = [ extra-cmake-modules ];

  meta.platforms = lib.platforms.all;
}
