{ lib, mkDerivation, fetchFromGitHub, substituteAll, udev
, pkg-config, qtbase, cmake, zlib, kmod, libXdmcp, qttools, qtx11extras, libdbusmenu }:

mkDerivation rec {
  version = "0.4.4";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "1fgvh2hsrm8vqbqq9g45skhyyrhhka4d8ngmyldkldak1fgmrvb7";
  };

  buildInputs = [
    udev
    qtbase
    zlib
    libXdmcp
    qttools
    qtx11extras
    libdbusmenu
  ];

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
    maintainers = with maintainers; [ kierdavis ];
  };
}
