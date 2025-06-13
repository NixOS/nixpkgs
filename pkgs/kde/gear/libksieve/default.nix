{
  mkKdeDerivation,
  qtwebengine,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "libksieve";

  extraNativeBuildInputs = [ qtwebengine ];
  extraBuildInputs = [ cyrus_sasl ];
}
