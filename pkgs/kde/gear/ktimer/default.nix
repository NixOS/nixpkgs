{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "ktimer";

  extraBuildInputs = [qt5compat];
}
