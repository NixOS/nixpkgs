{ fetchgit, stdenv, openssl, pkgconfig, db, cyrus_sasl
, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "isync-git-2015-11-08";
  rev = "46e792";

  src = fetchgit {
    url = "git://git.code.sf.net/p/isync/isync";
    inherit rev;
    sha256 = "1flm9lkgf1pa6aa678xr0yj5fxwh8c9jpjzd4002f4jjmcf4w57s";
  };

  buildInputs = [ openssl pkgconfig db cyrus_sasl autoconf automake ];

  preConfigure = ''
    touch ChangeLog
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
