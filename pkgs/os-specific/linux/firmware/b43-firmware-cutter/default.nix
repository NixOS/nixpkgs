{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "b43-fwcutter-019";

  src = fetchurl {
    url = "http://bues.ch/b43/fwcutter/${name}.tar.bz2";
    sha256 = "1ki1f5fy3yrw843r697f8mqqdz0pbsbqnvg4yzkhibpn1lqqbsnn";
  };

  patches = [ ./no-root-install.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Firmware extractor for cards supported by the b43 kernel module";
    homepage = http://wireless.kernel.org/en/users/Drivers/b43;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
