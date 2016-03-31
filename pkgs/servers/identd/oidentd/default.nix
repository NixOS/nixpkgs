{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "oidentd-2.0.8";

  CFLAGS = [ "--std=gnu89" ];

  src = fetchurl {
    url = "mirror://sourceforge/ojnk/${name}.tar.gz";
    sha256 = "0vzv2086rrxcaavrm3js7aqvyc0grgaqy78x61d8s7r8hz8vwk55";
  };

  meta = {
    homepage = http://ojnk.sourceforge.net/;
    description = "An implementation of the IDENT protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
