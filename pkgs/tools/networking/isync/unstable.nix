{ fetchgit, stdenv, openssl, pkgconfig, db, cyrus_sasl, zlib
, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "isync-git-20170329";
  rev = "1fdf793a3fb9f4704977ef49e0a490a83291ea4d";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    inherit rev;
    sha256 = "1m54jjww1b7a6rfw4wckzx6z1nd90psbb6cs38b9c015cs0vwaf5";
  };

  buildInputs = [ openssl pkgconfig db cyrus_sasl zlib autoconf automake ];

  preConfigure = ''
    touch ChangeLog
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ the-kenny ttuegel ];
    platforms = platforms.unix;
  };
}
