{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ktuberling";

  extraBuildInputs = [qtmultimedia];
}
