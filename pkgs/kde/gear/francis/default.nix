{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "francis";

  extraBuildInputs = [qtsvg];
}
