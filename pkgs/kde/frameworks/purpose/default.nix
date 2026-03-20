{
  mkKdeDerivation,
  qtdeclarative,
  kcmutils,
  kdeclarative,
  prison,
}:
mkKdeDerivation {
  pname = "purpose";

  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [
    kcmutils
    kdeclarative
    prison
  ];
}
