{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kde-cli-tools";

  extraBuildInputs = [ qtsvg ];
}
