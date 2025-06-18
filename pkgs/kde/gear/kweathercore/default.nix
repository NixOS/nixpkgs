{
  mkKdeDerivation,
  qtpositioning,
}:
mkKdeDerivation {
  pname = "kweathercore";

  extraNativeBuildInputs = [ qtpositioning ];
  extraBuildInputs = [ qtpositioning ];
}
