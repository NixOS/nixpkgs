{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kanagram";

  extraBuildInputs = [qtspeech];
}
