{
  mkKdeDerivation,
  qtdeclarative,
  kirigami,
}:
mkKdeDerivation {
  pname = "kquickcharts";

  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [ kirigami ];
}
