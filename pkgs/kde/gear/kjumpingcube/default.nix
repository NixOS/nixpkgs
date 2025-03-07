{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "kjumpingcube";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];

  meta.mainProgram = "kjumpingcube";
}
