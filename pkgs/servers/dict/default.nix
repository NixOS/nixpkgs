{ stdenv, fetchurl, which, bison, flex, libmaa, zlib, libtool }:

stdenv.mkDerivation rec {
  pname = "dictd";
  version = "1.13.0";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    sha256 = "1r413a78sa3mcrgddgdj1za34dj6mnd4dg66csqv2yz8fypm3fpf";
  };

  buildInputs = [ libmaa zlib ];

  nativeBuildInputs = [ bison flex libtool which ];

  # Makefile(.in) contains "clientparse.c clientparse.h: clientparse.y" which
  # causes bison to run twice, and break the build when this happens in
  # parallel.  Test with "make -j clientparse.c clientparse.h".  The error
  # message may be "mv: cannot move 'y.tab.c' to 'clientparse.c'".
  enableParallelBuilding = false;

  patchPhase = "patch -p0 < ${./buildfix.diff}";
  configureFlags = [
    "--enable-dictorg"
    "--datadir=/run/current-system/sw/share/dictd"
  ];

  meta = with stdenv.lib; {
    description = "Dict protocol server and client";
    homepage    = http://www.dict.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms   = platforms.linux;
  };
}
