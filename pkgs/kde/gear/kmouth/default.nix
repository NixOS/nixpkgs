{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kmouth";

  extraNativeBuildInputs = [ qtspeech ];
  meta.mainProgram = "kmouth";
}
