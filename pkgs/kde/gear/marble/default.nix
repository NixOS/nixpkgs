{
  mkKdeDerivation,

  perl,
  pkg-config,
  shared-mime-info,

  qtpositioning,
  qtsvg,
  qttools,
  qtwebengine,

  krunner,
  libplasma,
  phonon,

  gpsd,
  protobuf,
  shapelib,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "marble";

  # Fix build with Qt 6.9
  # FIXME: remove in 25.04
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/education/marble/-/commit/8d21b43f569adcd3bb76d3f9d921f2aaddb2c303.patch";
      hash = "sha256-UdY/4yxRMHcLb76A3elOLIEH+4v+AgVeUbUKzdavXHA=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/education/marble/-/commit/a14a3a911f5a8f152783a97410267a6fd98cce48.patch";
      hash = "sha256-WY28+Ea7DQ3qkNed25EtCtAKlM3Y/57gyM/DHQqdfCc=";
    })
  ];

  extraNativeBuildInputs = [
    perl
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtpositioning
    qtsvg
    qttools
    qtwebengine

    krunner
    libplasma
    phonon

    gpsd
    # FIXME: libwlocate
    protobuf
    shapelib
  ];
}
