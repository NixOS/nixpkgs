{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kimagemapeditor";

  extraNativeBuildInputs = [ qtwebengine ];
  extraBuildInputs = [ qtwebengine ];

  meta.mainProgram = "kimagemapeditor";
}
