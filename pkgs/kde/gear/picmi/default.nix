{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "picmi";

  extraBuildInputs = [qtsvg];
}
