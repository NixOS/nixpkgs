{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-481";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "19fxj0h10y5bhr3a1xa7kqvnwl44db3sdypz8jxl1q79yln8z8rz";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  preConfigure = "chmod +x ./configure";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
