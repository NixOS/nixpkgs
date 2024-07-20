{
  mkKdeDerivation,
  qt5compat,
  boost,
  qgpgme,
}:
mkKdeDerivation {
  pname = "libkleo";

  extraBuildInputs = [qt5compat boost];
  extraPropagatedBuildInputs = [qgpgme];
}
