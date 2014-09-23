{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-468";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1s36hppwcrvf2csw5xyjrbkyyfgshqp5vfg32ms480hdn76bbs28";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
