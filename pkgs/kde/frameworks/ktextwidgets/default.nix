{
  mkKdeDerivation,
  qtspeech,
  qttools,
}:
mkKdeDerivation {
  pname = "ktextwidgets";

  extraBuildInputs = [
    qtspeech
    qttools
  ];
}
