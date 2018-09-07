{ fetchurl, stdenv, openssl, pkgconfig, db, cyrus_sasl, perl }:

stdenv.mkDerivation rec {
  name = "isync-1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "173wd7x8y5sp94slzwlnb7zhgs32r57zl9xspl2rf4g3fqwmhpwd";
  };

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ openssl db cyrus_sasl ];

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
