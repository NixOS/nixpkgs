{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kanagram";

  extraBuildInputs = [ qtspeech ];
  meta.mainProgram = "kanagram";
}
