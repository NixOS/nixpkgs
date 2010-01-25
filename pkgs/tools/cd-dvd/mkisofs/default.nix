{ fetchurl, stdenv, gettext }:

stdenv.mkDerivation rec {
  name = "mkisofs-1.13";

  src = fetchurl {
    url = "mirror://gnu/isofsmk/${name}.tar.gz";
    sha256 = "13f8zynl64aaqjgxf0m1m2gbizdh7ndicg5d1bm6s0x97bqifrfn";
  };

  buildInputs = [ gettext ];

  doCheck = true;

  meta = {
    homepage = http://savannah.gnu.org/projects/isofsmk;

    description = "GNU mkisofs, an ISO 9660 filesystem builder";

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
