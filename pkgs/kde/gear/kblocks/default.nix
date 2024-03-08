{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kblocks";

  extraBuildInputs = [qtsvg];
}
