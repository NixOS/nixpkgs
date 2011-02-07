{ fetchurl, stdenv, openssl, pkgconfig, db4 }:

stdenv.mkDerivation rec {
  name = "isync-1.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/isync/isync-1.0.4.tar.gz";
    sha256 = "1xmgzypl5a3i0fz1ca55vfbs5mv2l9icwf2gk8rvlbwrkn2wid68";
  };

  buildInputs = [ openssl pkgconfig db4 ];

  meta = {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    licenses = [ "GPLv2+" ];

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
