{ fetchurl, stdenv, openssl, pkgconfig, db }:

stdenv.mkDerivation rec {
  name = "isync-1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "1960ah3fmp75cakd06lcx50n5q0yvfsadjh3lffhyvjvj7ava9d2";
  };

  buildInputs = [ openssl pkgconfig db ];

  meta = {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = [ "GPLv2+" ];

    maintainers = with stdenv.lib.maintainers; [ the-kenny viric ];
    platforms = stdenv.lib.platforms.unix;
  };
}
