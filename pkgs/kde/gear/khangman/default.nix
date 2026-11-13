{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "khangman";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "khangman";
}
