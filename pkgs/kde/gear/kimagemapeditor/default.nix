{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kimagemapeditor";

  extraNativeBuildInputs = [ qtwebengine ];
  meta.mainProgram = "kimagemapeditor";
}
