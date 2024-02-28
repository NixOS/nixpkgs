{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kbounce";

  extraBuildInputs = [qtsvg];
}
