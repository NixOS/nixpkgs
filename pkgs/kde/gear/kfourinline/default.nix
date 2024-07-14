{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "kfourinline";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg];
}
