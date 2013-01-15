{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.1";

  src = fetchurl {
    url = "https://01.org/powertop/sites/default/files/downloads/${name}.tar.gz";
    sha256 = "16161nlah4i4hq8vyx7ds1vq7icdzwm7gmyjg0xhcrs1r9n83m1x";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
