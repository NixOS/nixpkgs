{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  libical,
}:
mkKdeDerivation {
  pname = "kcalendarcore";

  hasPythonBindings = true;

  extraNativeBuildInputs = [
    qttools
  ];

  extraBuildInputs = [
    qtdeclarative
    libical
  ];
}
