{
  mkKdeDerivation,
  _7zz,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kapman";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];
}
