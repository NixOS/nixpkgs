{
  mkKdeDerivation,
  _7zz,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kigo";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];
  meta.mainProgram = "kigo";
}
