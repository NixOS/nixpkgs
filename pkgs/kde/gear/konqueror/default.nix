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

  extraCmakeFlags = [
    "-DWebEngineDictConverter_EXECUTABLE=${qtwebengine}/libexec/qwebengine_convert_dict"
  ];
}
