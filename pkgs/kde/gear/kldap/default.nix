{
  mkKdeDerivation,
  cyrus_sasl,
  openldap,
}:
mkKdeDerivation {
  pname = "kldap";

  extraBuildInputs = [
    cyrus_sasl
    openldap
  ];
}
