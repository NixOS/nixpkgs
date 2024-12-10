{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kfourinline";

  extraBuildInputs = [ qtsvg ];
}
