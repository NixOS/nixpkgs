{ fetchurl
, stdenv
, openssl
, autoreconfHook
, pkgconfig
, db
, zlib
, cyrus_sasl
, perl
}:

stdenv.mkDerivation rec {
  pname = "isync";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${pname}-${version}.tar.gz";
    sha256 = "1sphd30jplii58y2zmw365bckm6pszmapcy905zhjll1sm1ldjv8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig perl ];
  buildInputs = [ openssl db cyrus_sasl zlib ];

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
