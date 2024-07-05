{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "ksnakeduel";

  extraBuildInputs = [qtsvg];
  meta.mainProgram = "ksnakeduel";
}
