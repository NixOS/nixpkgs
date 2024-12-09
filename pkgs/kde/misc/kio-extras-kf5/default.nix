{
  stdenv,
  fetchurl,
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
# kio-extras-kf5 is kind of part of Gear, but also not released all the time,
# so handle it separately.
stdenv.mkDerivation rec {
  pname = "kio-extras-kf5";
  version = "24.02.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${version}/src/kio-extras-kf5-${version}.tar.xz";
    hash = "sha256-qar1jzuALINBu6HOuVBU+RUFnqRH9Z/8e5M8ynGxKsk=";
  };

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
