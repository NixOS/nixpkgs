{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "yakuake";

  extraBuildInputs = [qtsvg];
  meta.mainProgram = "yakuake";
}
