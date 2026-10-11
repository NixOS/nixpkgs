{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "blinken";

  extraBuildInputs = [
    qtmultimedia
    qtsvg
  ];
  meta.mainProgram = "blinken";
}
