{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kgoldrunner";

  extraNativeBuildInputs = [_7zz];
}
