{ stdenv, fetchFromGitHub, substituteAll, udev
, pkgconfig, qtbase, cmake, zlib, kmod }:

stdenv.mkDerivation rec {
  version = "0.3.2";
  name = "ckb-next-${version}";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "0ri5n7r1vhsgk6s64abvqcdrs5fmlwprw0rxiwfy0j8a9qcic1dr";
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

  patches = [
    ./install-dirs.patch
    ./systemd-service.patch
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
