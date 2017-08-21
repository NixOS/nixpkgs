{ stdenv, fetchurl, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "powertop-${version}";
  version = "2.9";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/powertop/powertop-v${version}.tar.gz";
    sha256 = "0l4jjlf05li2mc6g8nrss3h435wjhmnqd8m7v3kha3x0x7cbfzxa";
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
