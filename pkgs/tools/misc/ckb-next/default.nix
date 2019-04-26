{ stdenv, mkDerivation, fetchFromGitHub, substituteAll, udev
, pkgconfig, qtbase, cmake, zlib, kmod, gnused }:

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
  postPatch = ''
    sed -i 's:/usr/bin/env sed:${gnused}/bin/sed:g' linux/udev/99-ckb-next-daemon.rules
  '';

  meta = with stdenv.lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = "https://github.com/ckb-next/ckb-next";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
