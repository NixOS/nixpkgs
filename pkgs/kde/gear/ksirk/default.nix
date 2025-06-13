{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ksirk";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtmultimedia ];
}
