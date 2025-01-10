{
  mkKdeDerivation,
  boost,
}:
mkKdeDerivation {
  pname = "zanshin";

  extraBuildInputs = [boost];
}
