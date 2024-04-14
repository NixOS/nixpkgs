{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kmouth";

  extraBuildInputs = [qtspeech];
  meta.mainProgram = "kmouth";
}
