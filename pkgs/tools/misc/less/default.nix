{ lib, stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "581.2";

  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0fyqslvrasv19qjvqrwfwz2n7mnm93y61x9bcx09ga90mxyb8d6f";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
