{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "blinken";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "blinken";
}
