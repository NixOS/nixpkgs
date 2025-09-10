{
  mkKdeDerivation,
  kqtquickcharts,
}:
mkKdeDerivation {
  pname = "ktouch";

  extraBuildInputs = [ kqtquickcharts ];
}
