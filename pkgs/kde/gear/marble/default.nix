{
  mkKdeDerivation,

  perl,
  pkg-config,
  shared-mime-info,

  qtpositioning,
  qtserialport,
  qtsvg,
  qttools,
  qtwebengine,

  krunner,
  libplasma,
  phonon,

  gpsd,
  protobuf,
  shapelib,
}:
mkKdeDerivation {
  pname = "marble";

  extraNativeBuildInputs = [
    perl
    pkg-config
    shared-mime-info
    qtpositioning
    qtserialport
    qtwebengine
  ];

  extraBuildInputs = [
    qtpositioning
    qtserialport
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
