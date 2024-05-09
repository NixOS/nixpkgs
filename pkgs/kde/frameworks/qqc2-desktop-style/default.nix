{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  sonnet,
}:
mkKdeDerivation {
  pname = "qqc2-desktop-style";

  extraNativeBuildInputs = [qttools];
  extraBuildInputs = [qtdeclarative];
  extraPropagatedBuildInputs = [sonnet];
}
