{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "yakuake";

  extraBuildInputs = [qtsvg];
}
