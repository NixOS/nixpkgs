{
  mkKdeDerivation,
  qtdeclarative,
  boost,
}:
mkKdeDerivation {
  pname = "plasma-activities";

  extraBuildInputs = [qtdeclarative boost];
}
