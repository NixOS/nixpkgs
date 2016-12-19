{ stdenv, fetchFromGitHub, pkgconfig, intltool, autoconf, automake, alsaLib, gtk3, glibc, libnotify, libX11 }:

stdenv.mkDerivation rec {
  name = "pnmixer-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    rev = "v${version}";
    sha256 = "077l28qhr82ifqfwc2nqi5q1hmi6dyqqbhmjcsn27p4y433f3rpb";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake intltool ];

  buildInputs = [ alsaLib gtk3 glibc libnotify libX11 ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/nicklan/pnmixer;
    description = "ALSA mixer for the system tray";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ campadrenalin romildo ];
  };
}
