{ fetchgit, stdenv, openssl, pkgconfig, db, cyrus_sasl, zlib
, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "isync-git-20161218";
  rev = "77acc268123b8233843ca9bc3dcf90669efde08f";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    inherit rev;
    sha256 = "0i21cgmgm8acvd7xwdk9pll3kl6cxj9s1hakqzbwks8j4ncygwkj";
  };

  buildInputs = [ openssl pkgconfig db cyrus_sasl zlib autoconf automake ];

  preConfigure = ''
    touch ChangeLog
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ the-kenny ttuegel ];
    platforms = platforms.unix;
  };
}
