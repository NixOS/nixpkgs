{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kmplot";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kmplot";
}
