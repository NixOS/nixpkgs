{
  mkKdeDerivation,
  qtpositioning,
}:
mkKdeDerivation {
  pname = "kweathercore";

  extraBuildInputs = [ qtpositioning ];
}
