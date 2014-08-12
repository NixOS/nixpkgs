{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.5";

  src = fetchurl {
    url = "https://01.org/powertop/sites/default/files/downloads/${name}.tar.gz";
    sha256 = "02rwqbpasdayl201v0549gbp2f82rd0hqiv3i111r7npanjhhb4b";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
