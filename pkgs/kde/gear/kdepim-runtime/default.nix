{
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  qtnetworkauth,
  qtspeech,
  qtwebengine,
  cyrus_sasl,
  lib,
  libetebase,
  libkgapi,
}:
mkKdeDerivation {
  pname = "kdepim-runtime";

  extraNativeBuildInputs = [pkg-config shared-mime-info];
  # FIXME: libkolabxml
  extraBuildInputs = [qtnetworkauth qtspeech qtwebengine cyrus_sasl libetebase];

  qtWrapperArgs = [
    "--prefix SASL_PATH : ${lib.makeSearchPath "lib/sasl2" [ cyrus_sasl.out libkgapi ]}"
  ];
}
