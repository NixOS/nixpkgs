{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "1wh62mb102nxd5h3pnzakdf0lcyapv1yq44ndcc9wpw30az2rnq7";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
