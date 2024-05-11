{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
}:
mkKdeDerivation {
  pname = "qqc2-desktop-style";

  extraNativeBuildInputs = [qttools];
  extraBuildInputs = [qtdeclarative];
}
