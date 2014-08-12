{ fetchurl, stdenv, ncurses, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "htop-0.8.2.2";

  src = fetchurl {
    url = "https://github.com/max-horvath/htop-osx/archive/0.8.2.2.tar.gz";
    sha256 = "0qxibadn2lfqn10a5jmkv8r5ljfs0vaaa4j6psd7ppxa2w6bx5li";
  };

  buildInputs = [ autoconf automake ncurses ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "An interactive process viewer for Mac OS X";
    homepage = "https://github.com/max-horvath/htop-osx";
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ joelteon ];
  };
}
