{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2017.09.28";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "00gsh9hkrgg291my98plkrwlcpxkfrpq64pglf18kciqbf2bb7sw";
  };

  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
