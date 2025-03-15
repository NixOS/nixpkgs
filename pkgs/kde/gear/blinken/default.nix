{
  mkKdeDerivation,
  qtsvg,
  phonon,
}:
mkKdeDerivation {
  pname = "blinken";

  extraBuildInputs = [
    qtsvg
    phonon
  ];
  meta.mainProgram = "blinken";
}
