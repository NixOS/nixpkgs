{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kdev-python";

  extraBuildInputs = [ qt5compat ];
}
