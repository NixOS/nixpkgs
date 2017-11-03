{
  stdenv, fetchgit,
  autoconf, automake, cyrus_sasl, db, openssl, perl, pkgconfig, zlib,
}:

stdenv.mkDerivation rec {
  name = "isync-git-20170514";
  rev = "4b3768806278a70db696ba52645dc1b6eb8de58a";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    inherit rev;
    sha256 = "1cv1isw01cfp7724z6f4pf6k4rx3k1lg0pc1xcq17zpikx9d10fb";
  };

  nativeBuildInputs = [ autoconf automake perl pkgconfig ];
  buildInputs = [ cyrus_sasl db openssl zlib ];

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
