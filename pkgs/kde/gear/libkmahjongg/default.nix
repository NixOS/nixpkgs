{
  mkKdeDerivation,
  _7zz,
  svgcleaner,
  qtsvg,
}:
mkKdeDerivation {
  pname = "libkmahjongg";

  extraNativeBuildInputs = [_7zz svgcleaner];
  extraBuildInputs = [qtsvg];
}
