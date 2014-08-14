{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.6.1";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/powertop/${name}.tar.gz";
    sha256 = "1r103crmkdk617qrxqjzy2mlhaacbpg5q795546zwcxlbdnxwk03";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
