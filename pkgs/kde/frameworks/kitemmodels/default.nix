{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kitemmodels";

  extraBuildInputs = [ qtdeclarative ];
}
