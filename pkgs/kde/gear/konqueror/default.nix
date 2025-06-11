{
  mkKdeDerivation,
  qtwebengine,
  hunspell,
}:
mkKdeDerivation {
  pname = "konqueror";

  extraNativeBuildInputs = [ hunspell ];
  extraBuildInputs = [ qtwebengine ];

  extraCmakeFlags = [
    "-DWebEngineDictConverter_EXECUTABLE=${qtwebengine}/libexec/qwebengine_convert_dict"
  ];
}
