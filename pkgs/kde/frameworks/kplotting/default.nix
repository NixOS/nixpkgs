{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kplotting";

  extraBuildInputs = [ qttools ];
}
