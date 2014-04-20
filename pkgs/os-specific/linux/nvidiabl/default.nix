{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "nvidiabl-0.85-${kernel.version}";

  src = fetchurl {
    url = "https://github.com/guillaumezin/nvidiabl/archive/v0.85.tar.gz";
    sha256 = "1c7ar39wc8jpqh67sw03lwnyp0m9l6dad469ybqrgcywdiwxspwj";
  };

  preConfigure = ''
    sed -i 's|/sbin/depmod|#/sbin/depmod|' Makefile
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
  ];

  meta = {
    description = "Linux driver for setting the backlight brightness on laptops using NVIDIA GPU";
    homepage = https://github.com/guillaumezin/nvidiabl;
    license = stdenv.lib.licenses.gpl2;
  };
}
