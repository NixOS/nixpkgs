{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "lskat";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];

  meta.mainProgram = "lskat";
}
