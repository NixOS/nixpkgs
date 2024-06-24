{
  mkKdeDerivation,
  qtsvg,
  qtspeech,
  _7zz,
}:
mkKdeDerivation {
  pname = "knights";

  extraNativeBuildInputs = [_7zz];
  extraBuildInputs = [qtsvg qtspeech];
  meta.mainProgram = "knights";
}
