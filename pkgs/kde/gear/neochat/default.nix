{
  mkKdeDerivation,
  qtlocation,
  qtspeech,
  qtwebview,
}:
mkKdeDerivation {
  pname = "neochat";

  extraBuildInputs = [
    qtlocation
    qtspeech
    qtwebview
  ];
  meta.mainProgram = "neochat";
}
