{ fetchurl, stdenv, openssl, pkgconfig, db, cyrus_sasl }:

stdenv.mkDerivation rec {
  name = "isync-1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "0n8fwvv88h7ps7qs122kgh1yx5308765fiwqav5h7m272vg7hf43";
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
