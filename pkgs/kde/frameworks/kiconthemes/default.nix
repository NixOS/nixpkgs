{
  mkKdeDerivation,
  qtdeclarative,
  qtsvg,
  qttools,
}:
mkKdeDerivation {
  pname = "kiconthemes";

  extraBuildInputs = [
    qtdeclarative
    qtsvg
    qttools
  ];
}
