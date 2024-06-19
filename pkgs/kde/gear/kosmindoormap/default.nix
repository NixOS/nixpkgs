{
  mkKdeDerivation,
  bison,
  flex,
}:
mkKdeDerivation {
  pname = "kosmindoormap";

  extraNativeBuildInputs = [bison flex];
}
