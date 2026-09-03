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

  # breaks with split outputs
  # FIXME: track this down
  outputs = [ "out" ];

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
