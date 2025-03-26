{
  mkKdeDerivation,
  qtsvg,
  phonon,
}:
mkKdeDerivation {
  pname = "klettres";

  extraBuildInputs = [
    qtsvg
    phonon
  ];
  meta.mainProgram = "klettres";
}
