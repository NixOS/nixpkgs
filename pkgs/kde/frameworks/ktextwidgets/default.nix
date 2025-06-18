{
  mkKdeDerivation,
  qtspeech,
  qttools,
}:
mkKdeDerivation {
  pname = "ktextwidgets";

  extraNativeBuildInputs = [ qtspeech ];

  extraBuildInputs = [
    qtspeech
    qttools
  ];
}
