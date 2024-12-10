{
  mkKdeDerivation,
  extra-cmake-modules,
}:
mkKdeDerivation {
  pname = "kdevelop";

  extraBuildInputs = [ extra-cmake-modules ];
  # FIXME(qt5)
  meta.broken = true;
}
