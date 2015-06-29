{ stdenv, fetchurl, xz }:
stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2015.02.24";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "1i8d5cvijkfqhjdnb7imy36qpjqi7ra992j9bsl2qmcg0zfmnwb9";
  };
  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
  };
}
