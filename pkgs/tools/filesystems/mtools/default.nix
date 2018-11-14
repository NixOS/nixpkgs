{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.20";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1vcahr9s6zv1hnrx2bgjnzcas2y951q90r1jvvv4q9v5kwfd6qb0";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/mtools/;
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
