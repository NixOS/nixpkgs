{
  mkKdeDerivation,
  qtwebengine,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "libksieve";

  extraNativeBuildInputs = [ qtwebengine ];

  extraBuildInputs = [
    qtwebengine
    cyrus_sasl
  ];
}
