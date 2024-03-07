{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "ksudoku";

  extraBuildInputs = [qtsvg];
}
