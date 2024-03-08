{
  mkKdeDerivation,
  qtsvg,
  qcoro,
}:
mkKdeDerivation {
  pname = "kontrast";

  extraBuildInputs = [qtsvg qcoro];
}
