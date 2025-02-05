{
  mkKdeDerivation,
  qtdeclarative,
  libical,
}:
mkKdeDerivation {
  pname = "kcalendarcore";

  extraBuildInputs = [
    qtdeclarative
    libical
  ];
}
