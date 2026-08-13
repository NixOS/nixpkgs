{
  mkKdeDerivation,
  qtdeclarative,
  libical,
}:
mkKdeDerivation {
  pname = "kcalendarcore";

  hasPythonBindings = true;

  extraBuildInputs = [
    qtdeclarative
    libical
  ];
}
