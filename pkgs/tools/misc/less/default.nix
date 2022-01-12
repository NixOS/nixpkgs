{ lib, stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "596";

  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-QhqP1ZfnIELu/P6OV2NnerxL6EM/bA321zmhbMDk1cM=";
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
