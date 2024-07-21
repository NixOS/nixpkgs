{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kirigami-gallery";

  extraBuildInputs = [qtsvg];
  # FIXME(qt5)
  meta.broken = true;
}
