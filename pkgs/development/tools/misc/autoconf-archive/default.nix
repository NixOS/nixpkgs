{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2017.03.21";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "0rfpapadka2023qhy8294ca5awxpb8d4904js6kv7piby5ax8siq";
  };

  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = http://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
