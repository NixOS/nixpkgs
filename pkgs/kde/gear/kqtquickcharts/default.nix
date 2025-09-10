{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kqtquickcharts";

  extraBuildInputs = [ qtdeclarative ];
}
