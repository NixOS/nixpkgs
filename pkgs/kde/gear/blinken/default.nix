{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "blinken";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "blinken";
}
