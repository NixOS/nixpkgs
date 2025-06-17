{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "kwordquiz";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
  ];

  meta.mainProgram = "kwordquiz";
}
