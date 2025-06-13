{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "kmouth";

  extraNativeBuildInputs = [ qtspeech ];
  extraBuildInputs = [ qtspeech ];

  meta.mainProgram = "kmouth";
}
