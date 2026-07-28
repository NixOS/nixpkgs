{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kpimtextedit";

  extraBuildInputs = [ qt5compat ];
}
