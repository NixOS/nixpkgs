{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "bovo";

  extraBuildInputs = [qtsvg];
}
