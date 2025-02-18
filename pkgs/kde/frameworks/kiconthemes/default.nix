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
    qttools
  ];
  extraPropagatedBuildInputs = [
    qtsvg
  ];

  meta.mainProgram = "kiconfinder6";
}
