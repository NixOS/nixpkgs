{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.2";

  src = fetchurl {
    url = "https://01.org/powertop/sites/default/files/downloads/${name}.tar.gz";
    sha256 = "0a5haxawcjrlwwxx4j5kd4ad05gjmcr13v8gswfwfxcn7fyf2f8k";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
