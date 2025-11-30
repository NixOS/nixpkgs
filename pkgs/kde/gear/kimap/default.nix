{
  mkKdeDerivation,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "kimap";

  extraBuildInputs = [ cyrus_sasl ];
}
