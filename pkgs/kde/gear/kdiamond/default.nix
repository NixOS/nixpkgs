{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kdiamond";

  extraNativeBuildInputs = [_7zz];
}
