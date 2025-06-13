{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kconfig";

  extraPropagatedBuildInputs = [ qtdeclarative ];
}
