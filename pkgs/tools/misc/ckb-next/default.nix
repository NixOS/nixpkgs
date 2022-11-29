{ lib, mkDerivation, fetchFromGitHub, substituteAll, udev, stdenv
, pkg-config, qtbase, cmake, zlib, kmod, libXdmcp, qttools, qtx11extras, libdbusmenu
, withPulseaudio ? stdenv.isLinux, libpulseaudio
}:

mkDerivation rec {
  version = "0.5.0";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "sha256-yR1myagAqavAR/7lPdufcrJpPmXW7r4N4pxTMF6NbuE=";
  };

  buildInputs = [
    udev
    qtbase
    zlib
    libXdmcp
    qttools
    qtx11extras
    libdbusmenu
  ] ++ lib.optional withPulseaudio libpulseaudio;

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  cmakeFlags = [
    "-DINSTALL_DIR_ANIMATIONS=libexec"
    "-DUDEV_RULE_DIRECTORY=lib/udev/rules.d"
    "-DFORCE_INIT_SYSTEM=systemd"
    "-DDISABLE_UPDATER=1"
  ];

  patches = [
    ./install-dirs.patch
    (substituteAll {
      name = "ckb-next-modprobe.patch";
      src = ./modprobe.patch;
      inherit kmod;
    })
  ];

  meta = with lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = "https://github.com/ckb-next/ckb-next";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
