{
  mkKdeDerivation,
  qt5compat,
  boost,
}:
mkKdeDerivation {
  pname = "kactivitymanagerd";

  extraBuildInputs = [qt5compat boost];
}
