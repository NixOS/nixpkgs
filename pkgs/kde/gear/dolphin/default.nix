{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "dolphin";

  extraBuildInputs = [ qtmultimedia ];
}
