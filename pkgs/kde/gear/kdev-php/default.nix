{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kdev-php";
  # FIXME(qt5)
  meta.broken = true;
}
