{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kconfig";

  extraNativeBuildInputs = [qttools];
  extraPropagatedBuildInputs = [qtdeclarative];
}
