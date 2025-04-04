{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  libcanberra,
}:
mkKdeDerivation {
  pname = "knotifications";

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [
    qtdeclarative
    libcanberra
  ];
}
