{
  mkKdeDerivation,
  boost,
}:
mkKdeDerivation {
  pname = "rocs";

  extraBuildInputs = [boost];
  # FIXME(qt5)
  meta.broken = true;
}
