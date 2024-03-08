{
  stdenv,
  sources,
  kio-extras,
  cmake,
  libsForQt5,
  samba,
  libssh,
  libmtp,
  libimobiledevice,
  gperf,
  libtirpc,
  openexr,
  taglib,
  libappimage,
}:
stdenv.mkDerivation rec {
  pname = "kio-extras-kf5";
  inherit (sources.${pname}) version;

  src = sources.${pname};

  nativeBuildInputs = with libsForQt5; [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    qtbase

    kactivities
    kactivities-stats
    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdnssd
    kdoctools
    kdsoap
    kguiaddons
    ki18n
    kio
    libkexiv2
    phonon
    solid
    syntax-highlighting

    samba
    libssh
    libmtp
    libimobiledevice
    gperf
    libtirpc
    openexr
    taglib
    libappimage
  ];

  meta = kio-extras.meta;
}
