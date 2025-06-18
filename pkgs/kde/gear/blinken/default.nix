{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "blinken";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtmultimedia
    qtsvg
  ];

  meta.mainProgram = "blinken";
}
