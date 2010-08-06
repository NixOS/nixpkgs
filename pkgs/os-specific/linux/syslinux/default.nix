{ stdenv, fetchurl, nasm, perl }:

stdenv.mkDerivation rec {
  name = "syslinux-4.02";
  
  src = fetchurl {
    url = "mirror://kernel/linux/utils/boot/syslinux/4.xx/${name}.tar.bz2";
    sha256 = "0zrk6magnrfa7nmdk2rll7xaym9rapwqqgy0wdh3cfscjmcw9kwm";
  };

  patches = [ ./perl-deps.patch ];
  
  buildInputs = [ nasm perl ];

  preBuild =
    ''
      substituteInPlace gpxe/src/Makefile.housekeeping --replace /bin/echo $(type -P echo)
      makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin LIBDIR=$out/lib INCDIR=$out/include DATADIR=$out/share MANDIR=$out/share/man PERL=perl)
    '';
}
