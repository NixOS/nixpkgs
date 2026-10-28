{
  mkKdeDerivation,
  pkg-config,
  qtdeclarative,
  qtsvg,
  kirigami,
  aubio,
  fluidsynth,
}:
mkKdeDerivation {
  pname = "minuet";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtdeclarative
    qtsvg
    kirigami

    aubio
    fluidsynth
  ];
  meta.mainProgram = "minuet";
}
