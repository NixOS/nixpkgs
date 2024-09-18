{
  mkKdeDerivation,
  kdevelop-pg-qt,
}:
mkKdeDerivation {
  pname = "kdev-php";

  extraNativeBuildInputs = [kdevelop-pg-qt];
}
