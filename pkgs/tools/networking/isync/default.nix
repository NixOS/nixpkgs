{ fetchurl, stdenv, openssl, pkgconfig, db4 }:

stdenv.mkDerivation rec {
  name = "isync-1.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${name}.tar.gz";
    sha256 = "0bv3hw6mc9xi55q6lpyz1w3dyrk6rlxa8ny2x1b44mrnbrx7chz5";
  };

  patches = [ ./isync-recursice-imap.patch ]; # usefull patch to enable subfolders listing
  buildInputs = [ openssl pkgconfig db4 ];

  meta = {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    licenses = [ "GPLv2+" ];

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
