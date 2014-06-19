{ stdenv, fetchurl, nasm, perl, libuuid }:

stdenv.mkDerivation rec {
  name = "syslinux-6.02";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/boot/syslinux/${name}.tar.xz";
    sha256 = "0y2ld2s64s6vc5pf8rj36w71rq2cfax3c1iafp0w1qbjpxy1p8xg";
  };

  patches = [ ./perl-deps.patch ];

  buildInputs = [ nasm perl libuuid ];

  enableParallelBuilding = true;

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
