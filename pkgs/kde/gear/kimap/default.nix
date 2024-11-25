{
  mkKdeDerivation,
  cyrus-sasl,
}:
mkKdeDerivation {
  pname = "kimap";

  extraBuildInputs = [ cyrus-sasl ];
}
