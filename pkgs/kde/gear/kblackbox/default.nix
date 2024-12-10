{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kblackbox";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kblackbox";
}
