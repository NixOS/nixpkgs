{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "lskat";

  extraBuildInputs = [qtsvg];
}
