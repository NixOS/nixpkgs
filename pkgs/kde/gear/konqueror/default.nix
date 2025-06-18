{
  mkKdeDerivation,
  qtwebengine,
  hunspell,
}:
mkKdeDerivation {
  pname = "konqueror";

  extraNativeBuildInputs = [
    hunspell
    qtwebengine
  ];

  extraBuildInputs = [ qtwebengine ];

  extraCmakeFlags = [
    "-DWebEngineDictConverter_EXECUTABLE=${qtwebengine}/libexec/qwebengine_convert_dict"
  ];
}
