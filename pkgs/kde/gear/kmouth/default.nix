{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kmouth";

  extraBuildInputs = [qtspeech];
}
