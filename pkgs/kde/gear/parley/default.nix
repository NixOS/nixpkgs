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

  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "parley";
}
