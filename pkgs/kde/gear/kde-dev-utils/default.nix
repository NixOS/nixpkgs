{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kde-dev-utils";

  extraBuildInputs = [ qttools ];
}
