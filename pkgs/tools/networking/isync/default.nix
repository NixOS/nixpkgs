{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  perl,
  openssl,
  db,
  cyrus_sasl,
  zlib,
  Security,
  # Disabled by default as XOAUTH2 is an "OBSOLETE" SASL mechanism and this relies
  # on a package that isn't really maintained anymore:
  withCyrusSaslXoauth2 ? false,
  cyrus-sasl-xoauth2,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "isync";
  version = "1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/isync/${pname}-${version}.tar.gz";
    sha256 = "1zq0wwvmqsl9y71546dr0aygzn9gjjfiw19hlcq87s929y4p6ckw";
  };

  patches = [
    # Fixes "Fatal: buffer too small" error
    ./0001-Increase-imap_vprintf-buffer-size.patch
    # Fix #202595: SSL error "Socket error: ... unexpected eof while reading"
    # Source: https://sourceforge.net/p/isync/isync/ci/b6c36624f04cd388873785c0631df3f2f9ac4bf0/
    ./work-around-unexpected-EOF-error-messages-at-end-of-SSL-connections.patch
  ];

  nativeBuildInputs = [
    pkg-config
    perl
  ] ++ lib.optionals withCyrusSaslXoauth2 [ makeWrapper ];
  buildInputs = [
    openssl
    db
    cyrus_sasl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  postInstall = lib.optionalString withCyrusSaslXoauth2 ''
    wrapProgram "$out/bin/mbsync" \
        --prefix SASL_PATH : "${
          lib.makeSearchPath "lib/sasl2" [
            cyrus-sasl-xoauth2
            cyrus_sasl.out
          ]
        }"
  '';

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
    maintainers = with maintainers; [ primeos ];
    mainProgram = "mbsync";
  };
}
