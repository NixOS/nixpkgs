{
  mkKdeDerivation,
  qgpgme,
}:
mkKdeDerivation {
  pname = "isoimagewriter";

  extraBuildInputs = [qgpgme];
}
