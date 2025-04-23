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
}:
mkKdeDerivation {
  pname = "marble";

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
