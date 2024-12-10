{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kjumpingcube";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kjumpingcube";
}
