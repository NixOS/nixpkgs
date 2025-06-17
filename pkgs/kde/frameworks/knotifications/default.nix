{
  mkKdeDerivation,
  qtdeclarative,
  libcanberra,
}:
mkKdeDerivation {
  pname = "knotifications";

  hasPythonBindings = true;

  extraBuildInputs = [
    qtdeclarative
    libcanberra
  ];
}
