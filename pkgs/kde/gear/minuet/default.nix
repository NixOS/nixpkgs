{
  mkKdeDerivation,
  qtdeclarative,
  qtsvg,
  fluidsynth,
}:
mkKdeDerivation {
  pname = "minuet";

  extraBuildInputs = [qtdeclarative qtsvg fluidsynth];
}
