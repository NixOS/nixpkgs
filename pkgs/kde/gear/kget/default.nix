{
  mkKdeDerivation,
  qgpgme,
  libmms,
}:
mkKdeDerivation {
  pname = "kget";

  extraBuildInputs = [qgpgme libmms];
}
