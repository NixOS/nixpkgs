{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kblackbox";

  extraBuildInputs = [qtsvg];
}
