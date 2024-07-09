{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "klettres";

  extraBuildInputs = [qtsvg];
  meta.mainProgram = "klettres";
}
