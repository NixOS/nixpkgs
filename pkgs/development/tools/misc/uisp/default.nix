{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "uisp-20050207";

  src = fetchurl {
    url = http://mirror.switch.ch/mirror/gentoo/distfiles/uisp-20050207.tar.gz;
    sha256 = "1bncxp5yxh9r1yrp04vvhfiva8livi1pwic7v8xj99q09zrwahvw";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Tool for AVR microcontrollers which can interface to many hardware in-system programmers";
    license = stdenv.lib.licenses.gpl2;
    homepage = https://savannah.nongnu.org/projects/uisp;
    platforms = stdenv.lib.platforms.linux;
  };
}
