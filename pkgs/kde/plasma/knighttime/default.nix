{
  mkKdeDerivation,
  qtpositioning,
}:
mkKdeDerivation {
  pname = "knighttime";

  extraBuildInputs = [ qtpositioning ];
}
