{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kpeople";

  extraBuildInputs = [qtdeclarative];
}
