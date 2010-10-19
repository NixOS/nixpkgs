{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.15";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "169qjy3fmmhxiy0jljh84jvjh8mh1p8gglwqgjhq7hbw235fy399";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/mtools/;
    description = "GNU mtools, utilities to access MS-DOS disks";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
