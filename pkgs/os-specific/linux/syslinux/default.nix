{ stdenv, fetchurl, nasm, perl, libuuid }:

stdenv.mkDerivation rec {
  name = "syslinux-4.06";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/boot/syslinux/4.xx/${name}.tar.bz2";
    sha256 = "09md61npd5z64rv5s3knl4qsn2bqsn57irm5izk6snf46r77gdyv";
  };

  patches = [ ./perl-deps.patch ];

  buildInputs = [ nasm perl libuuid ];

  enableParallelBuilding = true;

  preBuild =
    ''
      substituteInPlace gpxe/src/Makefile.housekeeping --replace /bin/echo $(type -P echo)
      substituteInPlace gpxe/src/Makefile --replace /usr/bin/perl $(type -P perl)
      makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin LIBDIR=$out/lib INCDIR=$out/include DATADIR=$out/share MANDIR=$out/share/man PERL=perl)
    '';

  meta = {
    homepage = http://www.syslinux.org/;
    description = "A lightweight bootloader";
  };
}
