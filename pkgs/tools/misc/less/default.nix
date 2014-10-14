{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-470";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1vw6bp9wkr2ymvhmf0ikrv8m1zm5ww78s48ny7ks0zjf2i8xr4gi";
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
