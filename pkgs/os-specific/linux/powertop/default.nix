{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-2.8";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/powertop/${name}.tar.gz";
    sha256 = "0nlwazxbnn0k6q5f5b09wdhw0f194lpzkp3l7vxansqhfczmcyx8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
  '';

  meta = with stdenv.lib; {
    description = "Analyze power consumption on Intel-based laptops";
    homepage = https://01.org/powertop;
    license = licenses.gpl2;
    maintainers = with maintainers; [ chaoflow fpletz ];
    platforms = platforms.linux;
  };
}
