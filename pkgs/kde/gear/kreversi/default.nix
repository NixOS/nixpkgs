{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kreversi";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kreversi";
}
