{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-475";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1w7d10h6hzgz5zww8g4aja2fbl7xwx30vd07hcg1fcy7hm8yc1q2";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  preConfigure = "chmod +x ./configure";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
