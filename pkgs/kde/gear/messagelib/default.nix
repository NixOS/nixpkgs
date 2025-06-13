{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "messagelib";

  propagatedNativeBuildInputs = [ qtwebengine ];
  extraPropagatedBuildInputs = [ qtwebengine ];
}
