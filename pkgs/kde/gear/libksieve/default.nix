{
  mkKdeDerivation,
  qtwebengine,
  cyrus-sasl,
}:
mkKdeDerivation {
  pname = "libksieve";

  extraBuildInputs = [
    qtwebengine
    cyrus-sasl
  ];
}
