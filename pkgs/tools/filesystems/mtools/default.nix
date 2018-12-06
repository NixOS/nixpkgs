{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.21";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1kybydx74qgbwpnjvjn49msf8zipchl43d4cq8zzwcyvfkdzw7h2";
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
