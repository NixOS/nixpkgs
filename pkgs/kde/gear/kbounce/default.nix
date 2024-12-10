{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kbounce";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kbounce";
}
