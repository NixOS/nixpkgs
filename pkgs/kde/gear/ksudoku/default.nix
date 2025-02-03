{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "ksudoku";

  extraBuildInputs = [qtsvg];
  extraNativeBuildInputs = [_7zz];

  meta.mainProgram = "ksudoku";
}
