{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kdegraphics-mobipocket";

  extraBuildInputs = [ qt5compat ];
}
