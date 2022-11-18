{ lib, stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2022.09.03";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "sha256-4HRU8A2MrnkHvtQtB0d5iSeAmUdoTZTDcgek1joy9CM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
