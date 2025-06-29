{
  fetchpatch,
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
  libxslt,
}:
mkKdeDerivation {
  pname = "kdepim-runtime";

  # Backport patch recommended by upstream
  # FIXME: remove in next update
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/pim/kdepim-runtime/-/commit/25202045186262a081c960461a8b791f84fccb5c.patch";
      hash = "sha256-D769X/v16drueNNr4HfbIZPpjNul8qiKHpOu0BNcbc8=";
    })
  ];

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
    cyrus_sasl
    libetebase
  ];

  qtWrapperArgs = [
    "--prefix SASL_PATH : ${
      lib.makeSearchPath "lib/sasl2" [
        cyrus_sasl.out
        libkgapi
      ]
    }"
  ];
}
