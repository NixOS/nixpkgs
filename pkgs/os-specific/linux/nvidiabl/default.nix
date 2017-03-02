{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "nvidiabl-${version}-${kernel.version}";
  version = "0.87";

  src = fetchFromGitHub {
    owner = "guillaumezin";
    repo = "nvidiabl";
    rev = "v${version}";
    sha256 = "1hs61dxn84vsyvrd2s899dhgg342mhfkbdn1nkhcvly45hdp2nca";
  };

  hardeningDisable = [ "pic" ];

  patches = [ ./linux4compat.patch ];

  preConfigure = ''
    sed -i 's|/sbin/depmod|#/sbin/depmod|' Makefile
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
    "KVER=${kernel.modDirVersion}"
  ];

  meta = {
    description = "Linux driver for setting the backlight brightness on laptops using NVIDIA GPU";
    homepage = https://github.com/guillaumezin/nvidiabl;
    license = stdenv.lib.licenses.gpl2;
  };
}
