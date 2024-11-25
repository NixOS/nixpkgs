{
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  qtnetworkauth,
  qtspeech,
  qtwebengine,
  cyrus-sasl,
  lib,
  libetebase,
  libkgapi,
  libxslt,
}:
mkKdeDerivation {
  pname = "kdepim-runtime";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
    libxslt
  ];
  # FIXME: libkolabxml
  extraBuildInputs = [
    qtnetworkauth
    qtspeech
    qtwebengine
    cyrus-sasl
    libetebase
  ];

  qtWrapperArgs = [
    "--prefix SASL_PATH : ${
      lib.makeSearchPath "lib/sasl2" [
        cyrus-sasl.out
        libkgapi
      ]
    }"
  ];
}
