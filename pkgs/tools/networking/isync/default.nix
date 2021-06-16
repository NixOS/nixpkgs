{ stdenv, fetchurl, pkg-config, perl
, openssl, db, zlib, cyrus_sasl
}:

stdenv.mkDerivation rec {
  pname = "isync";
  version = "1.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${pname}-${version}.tar.gz";
    sha256 = "1vla4cc6viyfqhp54f29sy9i3fx7hmawmmnmw4f4bd2w4qqlgr8v";
  };

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ openssl db cyrus_sasl zlib ];

  meta = with stdenv.lib; {
    homepage = "http://isync.sourceforge.net/";
    # https://sourceforge.net/projects/isync/
    changelog = "https://sourceforge.net/p/isync/isync/ci/v${version}/tree/NEWS";
    description = "Free IMAP and MailDir mailbox synchronizer";
    longDescription = ''
      mbsync (formerly isync) is a command line application which synchronizes
      mailboxes. Currently Maildir and IMAP4 mailboxes are supported. New
      messages, message deletions and flag changes can be propagated both ways.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos lheckemann ];
  };
}
