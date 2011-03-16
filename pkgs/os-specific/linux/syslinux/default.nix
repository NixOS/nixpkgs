{ stdenv, fetchurl, nasm, perl }:

stdenv.mkDerivation rec {
  name = "syslinux-4.03";
  
  src = fetchurl {
    url = "mirror://kernel/linux/utils/boot/syslinux/4.xx/${name}.tar.bz2";
    sha256 = "0f6s1cnibw6j0jh9bn5qsx3vsar9l1w9b3xfjkvzglgr4kinfmf6";
  };

  patches = [ ./perl-deps.patch ];
  
  buildInputs = [ nasm perl ];

  preBuild =
    ''
      substituteInPlace gpxe/src/Makefile.housekeeping --replace /bin/echo $(type -P echo)
      substituteInPlace gpxe/src/Makefile --replace /usr/bin/perl $(type -P perl)
      makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin LIBDIR=$out/lib INCDIR=$out/include DATADIR=$out/share MANDIR=$out/share/man PERL=perl)
    '';
}
