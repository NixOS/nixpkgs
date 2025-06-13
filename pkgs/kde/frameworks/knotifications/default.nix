{
  mkKdeDerivation,
  qtdeclarative,
  libcanberra,
}:
mkKdeDerivation {
  pname = "knotifications";

  extraBuildInputs = [
    qtdeclarative
    libcanberra
  ];
}
