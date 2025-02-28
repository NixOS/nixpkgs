{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "parley";

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtwebengine
  ];
  meta.mainProgram = "parley";
}
