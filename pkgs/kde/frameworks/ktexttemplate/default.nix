{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "ktexttemplate";

  extraBuildInputs = [ qtdeclarative ];
}
