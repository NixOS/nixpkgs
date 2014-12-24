{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-471";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1y17zfrn91fs71jry5gp9ibj7darglhr42krimw7hqsjkbx17xip";
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
