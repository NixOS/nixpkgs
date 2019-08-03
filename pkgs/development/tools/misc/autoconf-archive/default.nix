{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "autoconf-archive-${version}";
  version = "2019.01.06";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "0gqya7nf4j5k98dkky0c3bnr0paciya91vkqazg7knlq621mq68p";
  };

  buildInputs = [ xz ];

  meta = with stdenv.lib; {
    description = "Archive of autoconf m4 macros";
    homepage = https://www.gnu.org/software/autoconf-archive/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
