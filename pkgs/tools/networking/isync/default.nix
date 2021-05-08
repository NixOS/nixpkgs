{ lib, stdenv, fetchurl, pkg-config, perl
, openssl, db, cyrus_sasl, zlib
, Security
}:

stdenv.mkDerivation rec {
  pname = "isync";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${pname}-${version}.tar.gz";
    sha256 = "0l01880fcyqn6xq9n8236ha5n2a3wl5g8rmv22z8nv5hgfsxndhd";
  };

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ openssl db cyrus_sasl zlib ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
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
