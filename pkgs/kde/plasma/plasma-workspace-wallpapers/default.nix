{
  mkKdeDerivation,
  extra-cmake-modules,
}:
mkKdeDerivation {
  pname = "plasma-workspace-wallpapers";

  extraBuildInputs = [extra-cmake-modules];
}
