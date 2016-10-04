{ stdenv, fetchurl, elfutils }:

stdenv.mkDerivation rec {
  name = "ltrace-0.7.3";

  src = fetchurl {
    url = mirror://debian/pool/main/l/ltrace/ltrace_0.7.3.orig.tar.bz2;
    sha256 = "00wmbdghqbz6x95m1mcdd3wd46l6hgcr4wggdp049dbifh3qqvqf";
  };

  buildInputs = [ elfutils ];

  preConfigure =
    ''
      configureFlags="--disable-werror"
      makeFlagsArray=(INSTALL="install -c")
    '';

  meta = {
    description = "Library call tracer";
    homepage = http://www.ltrace.org/;
    platforms = stdenv.lib.platforms.linux;
  };
}
