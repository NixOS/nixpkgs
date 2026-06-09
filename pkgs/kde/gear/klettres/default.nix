{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "klettres";

  extraBuildInputs = [
    qtmultimedia
    qtsvg
  ];
  meta.mainProgram = "klettres";
}
