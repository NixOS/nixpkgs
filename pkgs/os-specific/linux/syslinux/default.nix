{ stdenv, fetchurl, nasm, perl, libuuid }:

stdenv.mkDerivation rec {
  name = "syslinux-6.03";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/boot/syslinux/${name}.tar.xz";
    sha256 = "03l5iifwlg1wyb4yh98i0b7pd4j55a1c9y74q1frs47a5dnrilr6";
  };

  patches = [ ./perl-deps.patch ];

  buildInputs = [ nasm perl libuuid ];

  enableParallelBuilding = false; # problems on Hydra

  preBuild = ''
    substituteInPlace Makefile --replace /bin/pwd $(type -P pwd)
    substituteInPlace gpxe/src/Makefile.housekeeping --replace /bin/echo $(type -P echo)
    substituteInPlace gpxe/src/Makefile --replace /usr/bin/perl $(type -P perl)
  '';

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/sbin"
    "LIBDIR=$(out)/lib"
    "INCDIR=$(out)/include"
    "DATADIR=$(out)/share"
    "MANDIR=$(out)/share/man"
    "PERL=perl"
    "bios"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.syslinux.org/;
    description = "A lightweight bootloader";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
