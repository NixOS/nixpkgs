{
  mkKdeDerivation,
  qgpgme,
}:
mkKdeDerivation {
  pname = "isoimagewriter";

  extraBuildInputs = [qgpgme];
  meta.mainProgram = "isoimagewriter";
}
