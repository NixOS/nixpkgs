{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "krecorder";

  extraBuildInputs = [qtmultimedia];
}
