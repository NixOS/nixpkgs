{
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtdeclarative,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kirigami";

  extraNativeBuildInputs = [qtsvg qttools];
  extraBuildInputs = [qtdeclarative];
  extraPropagatedBuildInputs = [qt5compat];
}
