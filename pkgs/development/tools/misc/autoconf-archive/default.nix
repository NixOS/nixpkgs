{ lib, stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2021.02.19";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "sha256-6KbrnSjdy6j/7z+iEWUyOem/I5q6agGmt8/Hzq7GnL0=";
  };

  buildInputs = [ xz ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
