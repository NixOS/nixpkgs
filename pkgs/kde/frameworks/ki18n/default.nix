{
  mkKdeDerivation,
  qtdeclarative,
  python3,
}:
mkKdeDerivation {
  pname = "ki18n";

  extraBuildInputs = [qtdeclarative python3];
}
