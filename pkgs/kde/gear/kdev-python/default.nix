{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kdev-python";
  # FIXME(qt5)
  meta.broken = true;
}
