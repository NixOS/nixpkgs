{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "khangman";

  extraBuildInputs = [qtsvg];
}
