{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "artikulate";

  extraBuildInputs = [qtmultimedia];
  # FIXME(qt5)
  meta.broken = true;
}
