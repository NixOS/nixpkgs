{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-462";
 
  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-462.tar.gz;
    sha256 = "1kv5izyrkds8lkkzd46c9gxsnjgxbr7w4ficzma95dprcn92m97a";
  };
 
  buildInputs = [ncurses];
 
}
