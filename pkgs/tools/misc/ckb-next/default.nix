{ lib, mkDerivation, fetchFromGitHub, substituteAll, udev
, pkg-config, qtbase, cmake, zlib, kmod }:

mkDerivation rec {
  version = "0.4.2";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "1mkx1psw5xnpscdfik1kpzsnfhhkn3571i7acr9gxyjr27sckplc";
  };

  buildInputs = [
    udev
    qtbase
    zlib
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
