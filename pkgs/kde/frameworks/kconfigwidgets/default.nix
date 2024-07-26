{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kconfigwidgets";

  extraBuildInputs = [qttools];
}
