{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.22";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "08shiy9am4x65yg8l5mplj8jrvsimzbaf2id8cmfc02b00i0yb35";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--without-x";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/mtools/;
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
