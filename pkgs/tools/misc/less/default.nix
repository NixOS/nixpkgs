{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-462";

  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-462.tar.gz;
    sha256 = "1kv5izyrkds8lkkzd46c9gxsnjgxbr7w4ficzma95dprcn92m97a";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
