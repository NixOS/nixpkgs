{
  mkKdeDerivation,
  qtsvg,
  knotifications,
}:
mkKdeDerivation {
  pname = "francis";

  extraBuildInputs = [qtsvg knotifications];
}
