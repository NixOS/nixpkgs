{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  name = "less-529";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "02wspzv90cki8936m50qxk0vrribvwwqlva21nyvfx41qga2r96v";
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
