{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.16";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1m9fml46f86p30x24836x7sb7gwm5w0g4br06yfkjhnihrvk77kw";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/mtools/;
    description = "GNU mtools, utilities to access MS-DOS disks";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
