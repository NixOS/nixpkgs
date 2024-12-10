{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "ksudoku";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "ksudoku";
}
