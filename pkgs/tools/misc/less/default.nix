{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  name = "less-530";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1qpj2z38c53qmvqn8jaa0kq26q989cfbfjj4y0s6z17l1amr2gsh";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ stdenv.lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.eelco ];
  };
}
