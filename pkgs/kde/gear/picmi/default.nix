{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "picmi";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "picmi";
}
