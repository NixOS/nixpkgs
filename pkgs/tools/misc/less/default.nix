{ lib, stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "608";

  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${version}.tar.gz";
    sha256 = "02f2d9d6hyf03va28ip620gjc6rf4aikmdyk47h7frqj18pbx6m6";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
