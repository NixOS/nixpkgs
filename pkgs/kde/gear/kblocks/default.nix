{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kblocks";

  extraBuildInputs = [qtsvg];
  meta.mainProgram = "kblocks";
}
