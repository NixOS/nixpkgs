{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "pimcommon";

  extraBuildInputs = [ qttools ];
}
