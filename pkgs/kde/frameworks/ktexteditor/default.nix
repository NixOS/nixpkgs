{
  mkKdeDerivation,
  qtdeclarative,
  qtspeech,
  editorconfig-core-c,
}:
mkKdeDerivation {
  pname = "ktexteditor";

  extraBuildInputs = [
    qtdeclarative
    qtspeech
    editorconfig-core-c
  ];
}
