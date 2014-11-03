{ fetchurl, stdenv, openssl, pkgconfig, db }:

stdenv.mkDerivation rec {
  name = "isync-1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "14blgxhpl78bpr1291zb7n3y9g8jpgmnpdnbl0vp2qplw76zv9f3";
  };

  buildInputs = [ openssl pkgconfig db ];

  meta = {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = [ "GPLv2+" ];

    maintainers = with stdenv.lib.maintainers; [ the-kenny viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
