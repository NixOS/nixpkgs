{
  mkKdeDerivation,
  pkg-config,
  qtdeclarative,
  qtsvg,
  kirigami,
  fluidsynth,
}:
mkKdeDerivation {
  pname = "minuet";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtdeclarative
    qtsvg
    kirigami
    fluidsynth
  ];
  meta.mainProgram = "minuet";
}
