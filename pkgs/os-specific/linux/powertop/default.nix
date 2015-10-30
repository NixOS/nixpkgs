{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.7";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/powertop/${name}.tar.gz";
    sha256 = "1jkqqr3l1x98m7rgin1dgfzxqwj4vciw9lyyq1kl9bdswa818jwd";
  };

  buildInputs = [ gettext libnl ncurses pciutils pkgconfig zlib ];

  # Fix --auto-tune bug:
  # https://lists.01.org/pipermail/powertop/2014-December/001727.html
  patches = [ ./auto-tune.patch ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
  '';

  meta = {
    description = "Analyze power consumption on Intel-based laptops";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.linux;
  };
}
