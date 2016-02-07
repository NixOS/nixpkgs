{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.8";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/powertop/${name}.tar.gz";
    sha256 = "0nlwazxbnn0k6q5f5b09wdhw0f194lpzkp3l7vxansqhfczmcyx8";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
  '';

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
