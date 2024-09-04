{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "calindori";

  extraBuildInputs = [qtsvg];
}
