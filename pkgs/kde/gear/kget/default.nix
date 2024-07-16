{
  mkKdeDerivation,
  qgpgme,
  libmms,
}:
mkKdeDerivation {
  pname = "kget";

  extraBuildInputs = [qgpgme libmms];
  meta.mainProgram = "kget";
}
