{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  perl,
  openssl,
  db,
  cyrus_sasl,
  zlib,
  perl538Packages,
  autoreconfHook,
  Security,
  # Disabled by default as XOAUTH2 is an "OBSOLETE" SASL mechanism and this relies
  # on a package that isn't really maintained anymore:
  withCyrusSaslXoauth2 ? false,
  cyrus-sasl-xoauth2,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isync";
  version = "1.5.0-unstable-2024-09-29";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    rev = "3c4b5f1c83a568f18c14c93aab95c9a853edfd15";
    hash = "sha256-MRjWr88sxd3C+YTMCqEymxmLj5h+uJKh9mcG+aEqf64=";
  };

  # Fixes "Fatal: buffer too small" error
  # see https://sourceforge.net/p/isync/mailman/isync-devel/thread/87fsevvebj.fsf%40steelpick.2x.cz/
  env.NIX_CFLAGS_COMPILE = "-DQPRINTF_BUFF=4000";

  autoreconfPhase = ''
    echo "1.5.0-3c4b5" > VERSION
    echo "See https://sourceforge.net/p/isync/isync/ci/3c4b5f1c83a568f18c14c93aab95c9a853edfd15/log/?path=" > ChangeLog
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ] ++ lib.optionals withCyrusSaslXoauth2 [ makeWrapper ];
  buildInputs = [
    perl538Packages.TimeDate
    openssl
    db
    cyrus_sasl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

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
})
