{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "blinken";

  extraBuildInputs = [qtsvg];
}
