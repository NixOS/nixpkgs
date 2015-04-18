{ stdenv, fetchurl, xz }:
stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2014.10.15";

  src = fetchurl {
    url = "http://ftp.heanet.ie/mirrors/gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "198yrdf8bhrpl7insdyzn65zd60qll0gr9vpz7fl7dpcj78yc7gy";
  };
  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros.";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
  };
}
