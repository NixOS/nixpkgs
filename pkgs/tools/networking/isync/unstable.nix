{ fetchgit, stdenv, openssl, pkgconfig, db, cyrus_sasl
, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "isync-git-2015-11-08";
  rev = "46e792";

  src = fetchgit {
    url = "git://git.code.sf.net/p/isync/isync";
    inherit rev;
    sha256 = "02bm5m3bwpfns7qdwfybyl4fwa146n55v67pdchkhxaqpa4ddws1";
  };

  buildInputs = [ openssl pkgconfig db cyrus_sasl autoconf automake ];

  preConfigure = ''
    touch ChangeLog
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://isync.sourceforge.net/;
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
