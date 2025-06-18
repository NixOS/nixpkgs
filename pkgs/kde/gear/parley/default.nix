{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "parley";

  extraNativeBuildInputs = [
    qtmultimedia
    qtwebengine
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtwebengine
  ];

  meta.mainProgram = "parley";
}
