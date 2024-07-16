{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kongress";

  extraBuildInputs = [qtsvg];
}
