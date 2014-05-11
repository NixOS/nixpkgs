{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.3";

  src = fetchurl {
    url = "http://hisham.hm/htop/releases/1.0.3/htop-1.0.3.tar.gz";
    sha256 = "0a8qbpsifzjwc4f45xfwm48jhm59g6q5hlib4bf7z13mgy95fp05";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rob simons relrod ];
  };
}
