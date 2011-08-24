{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.17";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1dpch2wsiwhyg7xhsdvmc1pws8biwqkmnqjc3mdj2bd76273bk0f";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/mtools/;
    description = "GNU mtools, utilities to access MS-DOS disks";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
