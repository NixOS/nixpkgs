{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "plasma-nano";

  extraBuildInputs = [ qtsvg ];
}
