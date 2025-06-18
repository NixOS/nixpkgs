{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kdegraphics-mobipocket";

  extraNativeBuildInputs = [ qt5compat ];
  extraBuildInputs = [ qt5compat ];
}
