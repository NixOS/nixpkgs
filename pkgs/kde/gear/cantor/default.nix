{
  mkKdeDerivation,

  pkg-config,
  shared-mime-info,

  qtsvg,
  qttools,
  qtwebengine,

  libqalculate,
  libspectre,
  luajit,
  poppler,
}:
mkKdeDerivation {
  pname = "cantor";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];
  extraBuildInputs = [
    qtsvg
    qttools
    qtwebengine

    libqalculate
    libspectre
    luajit
    poppler
    # FIXME: can't find R, Julia - if anyone needs this, feel free to investigate
  ];
}
