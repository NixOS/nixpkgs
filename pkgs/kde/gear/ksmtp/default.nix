{
  mkKdeDerivation,
  qt5compat,
  cyrus-sasl,
}:
mkKdeDerivation {
  pname = "ksmtp";

  extraBuildInputs = [
    qt5compat
    cyrus-sasl
  ];
}
