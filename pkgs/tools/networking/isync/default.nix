{ fetchurl, stdenv, openssl, pkgconfig, db }:

stdenv.mkDerivation rec {
  name = "isync-1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "51f5618c239013fb770f98ae269f24ee417214efaaf7e22821b4a27cf9a9213c";
  };

  buildInputs = [ openssl pkgconfig db ];

  meta = {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = [ "GPLv2+" ];

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
