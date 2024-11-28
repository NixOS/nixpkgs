{
  mkKdeDerivation,
  kconfigwidgets,
}:
mkKdeDerivation {
  pname = "kmailtransport";

  extraBuildInputs = [ kconfigwidgets ];
}
