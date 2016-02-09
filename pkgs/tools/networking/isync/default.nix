{ fetchurl, stdenv, openssl, pkgconfig, db, cyrus_sasl }:

stdenv.mkDerivation rec {
  name = "isync-1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "1bij6nm06ghkg98n2pdyacam2fyg5y8f7ajw0d5653m0r4ldw5p7";
  };

  buildInputs = [ openssl pkgconfig db cyrus_sasl ];

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ the-kenny viric ];
    platforms = platforms.unix;
  };
}
