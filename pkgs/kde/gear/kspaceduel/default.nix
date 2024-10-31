{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kspaceduel";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kspaceduel";
}
