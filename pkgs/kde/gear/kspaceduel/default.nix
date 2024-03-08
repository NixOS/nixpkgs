{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kspaceduel";

  extraBuildInputs = [qtsvg];
}
