{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "knavalbattle";

  extraNativeBuildInputs = [_7zz];

  meta.mainProgram = "knavalbattle";
}
