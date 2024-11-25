{
  mkKdeDerivation,
  cyrus-sasl,
  openldap,
}:
mkKdeDerivation {
  pname = "kldap";

  extraBuildInputs = [
    cyrus-sasl
    openldap
  ];
}
