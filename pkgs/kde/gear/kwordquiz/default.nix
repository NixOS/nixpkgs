{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "kwordquiz";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kwordquiz";
}
