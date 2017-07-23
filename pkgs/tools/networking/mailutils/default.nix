{ stdenv, fetchgit, fetchpatch
, autoconf, automake, bison, dejagnu, flex, gettext, git, libtool, pkgconfig, rsync, wget
, gdbm, pam, readline, ncurses, gnutls, guile, texinfo, gnum4, sasl, fribidi, nettools
, gss, mysql }:

stdenv.mkDerivation rec {
  name = "${project}-${version}";
  project = "mailutils";
  version = "3.2";

  # Official release misses readmsg/tests/hdr.at, so we use git instead:
  # url = "mirror://gnu/${project}/${name}.tar.xz";
  src = fetchgit {
    url = "git://git.savannah.gnu.org/${project}.git";
    rev = "release-3.2";
    leaveDotGit = true;  # for ./bootstrap
    sha256 = "1ixvxk1yv36ak2mgi1gbnr2xzfqz0p73x2lxwxlm1is2d9cvd1kh";
  };

  nativeBuildInputs = [
    autoconf automake bison flex gettext git libtool pkgconfig rsync wget
  ] ++ stdenv.lib.optional doCheck dejagnu;

  buildInputs = [
    gdbm pam readline ncurses gnutls guile texinfo gnum4 sasl fribidi nettools
    gss mysql.lib
  ];

  patches = [
    (fetchpatch {
      url = "http://git.gnu.org.ua/cgit/mailutils.git/patch/?id=afbb33cf9ff750e93a9a4c1f51a3b62d584f056e";
      sha256 = "1w72ymxlkqj2y3gqd2r27g79hxw7xa6j790shsg9i5jhhz3vknjx";
    })
    ./fix-build-mb-len-max.patch
    ./fix-test-ali-awk.patch
    ./path-to-cat.patch
  ];

  postPatch = ''
    sed -e '/AM_GNU_GETTEXT_VERSION/s/0.18/0.19/' -i configure.ac
    sed -i -e '/chown root:mail/d' \
           -e 's/chmod [24]755/chmod 0755/' \
      */Makefile{.in,.am}
    git add gnulib
    bash -ex bootstrap
  '';

  configureFlags = [
    "--with-gssapi"
    "--with-mysql"
  ];

  preCheck = ''
    # Disable comsat tests that fail without tty in the sandbox.
    tty -s || echo > comsat/tests/testsuite.at
    # Provide libraries for mhn.
    export LD_LIBRARY_PATH=$(pwd)/lib/.libs
  '';
  postCheck = "unset LD_LIBRARY_PATH";

  doCheck = true;
  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
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
      servers, mail reporting utility comsatd, general-purpose mail delivery
      agent maidag, mail filtering program sieve, and an implementation of MH
      message handling system.
    '';

    license = with licenses; [
      lgpl3Plus /* libraries */
      gpl3Plus /* tools */
    ];

    maintainers = with maintainers; [ orivej vrthra ];

    homepage = http://www.gnu.org/software/mailutils/;

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = platforms.gnu;
  };
}
