{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kdeplasma-addons";

  extraNativeBuildInputs = [ qtwebengine ];
  extraBuildInputs = [ qtwebengine ];
}
