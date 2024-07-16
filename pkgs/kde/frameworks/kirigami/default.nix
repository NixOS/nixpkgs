{
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtdeclarative,
  qt5compat,
  kitemmodels,
}:
mkKdeDerivation {
  pname = "kirigami";

  extraNativeBuildInputs = [qtsvg qttools];
  extraBuildInputs = [qtdeclarative];
  extraPropagatedBuildInputs = [qt5compat kitemmodels];
}
