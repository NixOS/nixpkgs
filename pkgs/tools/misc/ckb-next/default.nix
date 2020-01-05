{ stdenv, mkDerivation, fetchFromGitHub, substituteAll, udev
, pkgconfig, qtbase, cmake, zlib, kmod }:

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
    pkgconfig
    cmake
  ];

  cmakeFlags = [
    "-DINSTALL_DIR_ANIMATIONS=libexec"
    "-DUDEV_RULE_DIRECTORY=lib/udev/rules.d"
    "-DFORCE_INIT_SYSTEM=systemd"
  ];

  patches = [
    ./install-dirs.patch
    (substituteAll {
      name = "ckb-next-modprobe.patch";
      src = ./modprobe.patch;
      inherit kmod;
    })
  ];

  meta = with stdenv.lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = https://github.com/ckb-next/ckb-next;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
