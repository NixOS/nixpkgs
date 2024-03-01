{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcmutils";

  extraPropagatedBuildInputs = [qtdeclarative];
}
