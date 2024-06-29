{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "kblackbox";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];

  meta.mainProgram = "kblackbox";
}
