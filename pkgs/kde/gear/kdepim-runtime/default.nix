{
  mkKdeDerivation,
  shared-mime-info,
  qtnetworkauth,
  qtspeech,
  qtwebengine,
  cyrus_sasl,
  lib,
  libkgapi,
  libxslt,
}:
mkKdeDerivation {
  pname = "kdepim-runtime";

  extraNativeBuildInputs = [shared-mime-info libxslt];
  # FIXME: libkolabxml, libetebase
  extraBuildInputs = [qtnetworkauth qtspeech qtwebengine cyrus_sasl];

  qtWrapperArgs = [
    "--prefix SASL_PATH : ${lib.makeSearchPath "lib/sasl2" [ cyrus_sasl.out libkgapi ]}"
  ];
}
