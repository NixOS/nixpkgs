{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ksirk";

  extraNativeBuildInputs = [ qtmultimedia ];
}
