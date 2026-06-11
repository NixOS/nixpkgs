{
  mkKdeDerivation,
  qtdeclarative,
  kdeclarative,
}:
mkKdeDerivation {
  pname = "purpose";

  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [
    kdeclarative
  ];
}
