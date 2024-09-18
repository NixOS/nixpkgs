{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "qmlkonsole";

  extraBuildInputs = [qtsvg];
  meta.mainProgram = "qmlkonsole";
}
