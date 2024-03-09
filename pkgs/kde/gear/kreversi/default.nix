{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kreversi";

  extraBuildInputs = [qtsvg];
}
