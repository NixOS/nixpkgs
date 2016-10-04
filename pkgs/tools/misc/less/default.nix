{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  name = "less-483";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "07z43kwbmba2wh3q1gps09l72p8izfagygmqq1izi50s2h51mfvy";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ stdenv.lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
