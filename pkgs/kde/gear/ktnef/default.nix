{
  mkKdeDerivation,
  kcalutils,
}:
mkKdeDerivation {
  pname = "ktnef";

  extraBuildInputs = [ kcalutils ];
}
