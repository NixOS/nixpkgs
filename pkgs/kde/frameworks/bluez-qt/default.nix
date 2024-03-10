{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "bluez-qt";

  extraBuildInputs = [qtdeclarative];
}
