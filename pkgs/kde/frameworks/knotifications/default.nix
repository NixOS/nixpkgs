{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  libcanberra,
}:
mkKdeDerivation {
  pname = "knotifications";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [
    qtdeclarative
    libcanberra
  ];
}
