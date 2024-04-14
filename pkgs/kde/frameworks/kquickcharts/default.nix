{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kquickcharts";

  extraBuildInputs = [qtdeclarative];
}
