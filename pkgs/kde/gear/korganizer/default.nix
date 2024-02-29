{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "korganizer";

  extraBuildInputs = [qttools];
}
