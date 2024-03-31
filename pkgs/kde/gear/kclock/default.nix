{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "kclock";

  extraBuildInputs = [qtsvg qtmultimedia];
}
