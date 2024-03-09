{
  mkKdeDerivation,
  shared-mime-info,
  qtnetworkauth,
  qtspeech,
  qtwebengine,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "kdepim-runtime";

  extraNativeBuildInputs = [shared-mime-info];
  # FIXME: libkolabxml, libetebase
  extraBuildInputs = [qtnetworkauth qtspeech qtwebengine cyrus_sasl];
}
