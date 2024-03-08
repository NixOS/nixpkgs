{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kjumpingcube";

  extraBuildInputs = [qtsvg];
}
