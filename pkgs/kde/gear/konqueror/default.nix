{
  mkKdeDerivation,
  qtwebengine,
  hunspell,
}:
mkKdeDerivation {
  pname = "konqueror";

  extraBuildInputs = [qtwebengine hunspell];

  extraCmakeFlags = [
    "-DWebEngineDictConverter_EXECUTABLE=${qtwebengine}/libexec/qwebengine_convert_dict"
  ];
}
