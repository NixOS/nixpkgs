{ stdenv, fetchurl, gettext, libnl1, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.0";
  src = fetchurl {
    url = "https://01.org/powertop/sites/default/files/downloads/${name}.tar.bz2";
    sha256 = "7af51d320856b3446bcc314c9414385f3b05b9360f650883b0210cd3b12c5c1c";
  };

  buildInputs = [ gettext libnl1 ncurses pciutils pkgconfig zlib ];

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
