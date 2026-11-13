{
  mkKdeDerivation,
  boost,
}:
mkKdeDerivation {
  pname = "rocs";

  extraBuildInputs = [ boost ];
}
