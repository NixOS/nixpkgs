{
  mkKdeDerivation,
  qtspeech,
}:
mkKdeDerivation {
  pname = "ktextwidgets";

  extraNativeBuildInputs = [ qtspeech ];
}
