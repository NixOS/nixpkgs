{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2016.03.20";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "0dz4fnc723jqn3by22ds5fys7g31apzm1r9allldvva0yvzjxyw8";
  };

  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
