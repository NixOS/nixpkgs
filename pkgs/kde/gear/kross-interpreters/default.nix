{
  mkKdeDerivation,
  extra-cmake-modules,
}:
mkKdeDerivation {
  pname = "kross-interpreters";

  extraBuildInputs = [extra-cmake-modules];
  # FIXME(qt5)
  meta.broken = true;
}
