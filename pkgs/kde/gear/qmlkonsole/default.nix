{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "qmlkonsole";

  extraBuildInputs = [qtsvg];
}
