{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "artikulate";

  extraBuildInputs = [ qtmultimedia ];
}
