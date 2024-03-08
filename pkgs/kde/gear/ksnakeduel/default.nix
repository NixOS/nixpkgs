{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "ksnakeduel";

  extraBuildInputs = [qtsvg];
}
