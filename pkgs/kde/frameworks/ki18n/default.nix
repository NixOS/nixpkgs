{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "ki18n";

  extraBuildInputs = [qtdeclarative];
}
