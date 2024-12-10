{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "bovo";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "bovo";
}
