{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "lskat";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "lskat";
}
