{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, dejagnu
, gettext
, gnum4
, pkg-config
, texinfo
, fribidi
, gdbm
, gnutls
, gss
, guile
, libmysqlclient
, mailcap
, nettools
, pam
, readline
, ncurses
, python3
, sasl
, system-sendmail
, libxcrypt
, mkpasswd

, pythonSupport ? true
, guileSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "mailutils";
  version = "3.15";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-t9DChsNS/MfaeXjP1hfMZnNrIfqJGqT4iFX1FjVPLds=";
  };

  separateDebugInfo = true;

  postPatch = ''
    sed -i -e '/chown root:mail/d' \
           -e 's/chmod [24]755/chmod 0755/' \
      */Makefile{.in,.am}
    sed -i 's:/usr/lib/mysql:${libmysqlclient}/lib/mysql:' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gnum4
    pkg-config
    texinfo
  ];

  buildInputs = [
    fribidi
    gdbm
    gnutls
    gss
    libmysqlclient
    mailcap
    ncurses
    pam
    readline
    sasl
    libxcrypt
  ] ++ lib.optionals stdenv.isLinux [ nettools ]
  ++ lib.optionals pythonSupport [ python3 ]
  ++ lib.optionals guileSupport [ guile ];

  patches = [
    ./fix-build-mb-len-max.patch
    ./path-to-cat.patch
    # Fix cross-compilation
    # https://lists.gnu.org/archive/html/bug-mailutils/2020-11/msg00038.html
    (fetchpatch {
      url = "https://lists.gnu.org/archive/html/bug-mailutils/2020-11/txtiNjqcNpqOk.txt";
      sha256 = "0ghzqb8qx2q8cffbvqzw19mivv7r5f16whplzhm7hdj0j2i6xf6s";
    })
    # https://github.com/NixOS/nixpkgs/issues/223967
    # https://lists.gnu.org/archive/html/bug-mailutils/2023-04/msg00000.html
    ./don-t-use-descrypt-password-in-the-test-suite.patch
  ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-gssapi"
    "--with-gsasl"
    "--with-mysql"
    "--with-path-sendmail=${system-sendmail}/bin/sendmail"
    "--with-mail-rc=/etc/mail.rc"
    "DEFAULT_CUPS_CONFDIR=${mailcap}/etc" # provides mime.types to mimeview
  ] ++ lib.optional (!pythonSupport) "--without-python"
    ++ lib.optional (!guileSupport) "--without-guile";

  nativeCheckInputs = [ dejagnu mkpasswd ];
  doCheck = !stdenv.isDarwin; # ERROR: All 46 tests were run, 46 failed unexpectedly.
  doInstallCheck = false; # fails

  preCheck = ''
    # Disable comsat tests that fail without tty in the sandbox.
    tty -s || echo > comsat/tests/testsuite.at
    # Remove broken macro
    sed -i '/AT_TESTED/d' libmu_scm/tests/testsuite.at
    # Provide libraries for mhn.
    export LD_LIBRARY_PATH=$(pwd)/lib/.libs
  '';

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  meta = with lib; {
    description = "Rich and powerful protocol-independent mail framework";

    longDescription = ''
      GNU Mailutils is a rich and powerful protocol-independent mail
      framework.  It contains a series of useful mail libraries, clients, and
      servers.  These are the primary mail utilities for the GNU system.  The
      central library is capable of handling electronic mail in various
      mailbox formats and protocols, both local and remote.  Specifically,
      this project contains a POP3 server, an IMAP4 server, and a Sieve mail
      filter.  It also provides a POSIX `mailx' client, and a collection of
      other handy tools.

      The GNU Mailutils libraries supply an ample set of primitives for
      handling electronic mail in programs written in C, C++, Python or
      Scheme.

      The utilities provided by Mailutils include imap4d and pop3d mail
      servers, mail reporting utility comsatd, mail filtering program sieve,
      and an implementation of MH message handling system.
    '';

    license = with licenses; [
      lgpl3Plus /* libraries */
      gpl3Plus /* tools */
    ];

    maintainers = with maintainers; [ orivej vrthra ];

    homepage = "https://www.gnu.org/software/mailutils/";
    changelog = "https://git.savannah.gnu.org/cgit/mailutils.git/tree/NEWS";

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = platforms.gnu ++ platforms.unix;
  };
}
