{
  mkKdeDerivation,
  qtscxml,
  qtsvg,
}:
mkKdeDerivation {
  pname = "konquest";

  extraBuildInputs = [qtscxml qtsvg];
}
