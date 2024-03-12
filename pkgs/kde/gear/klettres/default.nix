{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "klettres";

  extraBuildInputs = [qtsvg];
}
