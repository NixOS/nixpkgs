{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "plasma-sdk";

  extraBuildInputs = [ qtsvg ];
}
