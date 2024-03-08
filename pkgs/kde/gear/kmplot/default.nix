{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kmplot";

  extraBuildInputs = [qtsvg];
}
