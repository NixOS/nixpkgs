{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "krecorder";

  extraBuildInputs = [qtmultimedia];
  meta.mainProgram = "krecorder";
}
