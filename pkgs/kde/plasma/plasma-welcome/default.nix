{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "plasma-welcome";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "plasma-welcome";
}
