{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "ndisc6-1.0.1";

  src = fetchurl {
    url = "http://www.remlab.net/files/ndisc6/archive/${name}.tar.bz2";
    sha256 = "1pggc9x3zki1sv08rs8x4fm7pmd3sn1nwkan3szax19xg049xbqx";
  };

  buildInputs = [ perl ];

  meta = {
    homepage = http://www.remlab.net/ndisc6/;
    description = "A small collection of useful tools for IPv6 networking";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
