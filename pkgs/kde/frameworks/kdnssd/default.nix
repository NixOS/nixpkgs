{
  mkKdeDerivation,
  avahi,
}:
mkKdeDerivation {
  pname = "kdnssd";

  extraBuildInputs = [ avahi ];
}
