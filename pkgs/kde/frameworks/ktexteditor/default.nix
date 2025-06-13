{
  mkKdeDerivation,
  qtdeclarative,
  qtspeech,
  editorconfig-core-c,
}:
mkKdeDerivation {
  pname = "ktexteditor";

  extraNativeBuildInputs = [ qtspeech ];

  extraBuildInputs = [
    qtdeclarative
    qtspeech
    editorconfig-core-c
  ];
}
