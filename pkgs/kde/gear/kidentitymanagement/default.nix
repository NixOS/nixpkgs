{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kidentitymanagement";

  extraBuildInputs = [ qtdeclarative ];
}
