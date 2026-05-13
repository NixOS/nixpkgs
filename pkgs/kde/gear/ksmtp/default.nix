{
  mkKdeDerivation,
  qt5compat,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "ksmtp";

  extraBuildInputs = [
    qt5compat
    cyrus_sasl
  ];
}
