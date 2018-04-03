{ stdenv, fetchurl, fetchpatch, autoreconfHook, dejagnu, gettext, pkgconfig
, gdbm, pam, readline, ncurses, gnutls, guile, texinfo, gnum4, sasl, fribidi, nettools
, python, gss, mysql }:

let
  p = "https://raw.githubusercontent.com/gentoo/gentoo/9c921e89d51876fd876f250324893fd90c019326/net-mail/mailutils/files";
in stdenv.mkDerivation rec {
  name = "${project}-${version}";
  project = "mailutils";
  version = "3.2";

  src = fetchurl {
    url = "mirror://gnu/${project}/${name}.tar.xz";
    sha256 = "0zh7xn8yvnw9zkc7gi5290i34viwxp1rn0g1q9nyvmckkvk59lwn";
  };

  nativeBuildInputs = [
    autoreconfHook gettext pkgconfig
  ] ++ stdenv.lib.optional doCheck dejagnu;
  buildInputs = [
    gdbm pam readline ncurses gnutls guile texinfo gnum4 sasl fribidi nettools
    gss mysql.connector-c python
  ];

  patches = [
    (fetchpatch {
      url = "https://git.savannah.gnu.org/cgit/mailutils.git/patch/?id=afbb33cf9ff";
      excludes = [ "NEWS" ];
      sha256 = "0yzkfx3j1zkkb43fhchjqphw4xznbclj39bjzjggv32gppy6d1db";
    })
    ./fix-build-mb-len-max.patch
    ./fix-test-ali-awk.patch
    ./path-to-cat.patch
  ];

  doCheck = true;
  enableParallelBuilding = false;
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-gssapi"
    "--with-gsasl"
    "--with-mysql"
  ];

  readmsg-tests = stdenv.lib.optionals doCheck [
    (fetchurl { url = "${p}/hdr.at"; sha256 = "0phpkqyhs26chn63wjns6ydx9468ng3ssbjbfhcvza8h78jlsd98"; })
    (fetchurl { url = "${p}/nohdr.at"; sha256 = "1vkbkfkbqj6ml62s1am8i286hxwnpsmbhbnq0i2i0j1i7iwkk4b7"; })
    (fetchurl { url = "${p}/twomsg.at"; sha256 = "15m29rg2xxa17xhx6jp4s2vwa9d4khw8092vpygqbwlhw68alk9g"; })
    (fetchurl { url = "${p}/weed.at"; sha256 = "1101xakhc99f5gb9cs3mmydn43ayli7b270pzbvh7f9rbvh0d0nh"; })
  ];

  postPatch = ''
    sed -i -e '/chown root:mail/d' \
           -e 's/chmod [24]755/chmod 0755/' \
      */Makefile{.in,.am}
    sed -i 's:/usr/lib/mysql:${mysql.connector-c}/lib/mysql:' configure.ac
    sed -i 's/0\.18/0.19/' configure.ac
    sed -i -e 's:mysql/mysql.h:mysql.h:' \
           -e 's:mysql/errmsg.h:errmsg.h:' \
      sql/mysql.c
  '';

  NIX_CFLAGS_COMPILE = "-L${mysql.connector-c}/lib/mysql -I${mysql.connector-c}/include/mysql";

  preCheck = ''
    # Add missing test files
    cp ${builtins.toString readmsg-tests} readmsg/tests/
    for f in hdr.at nohdr.at twomsg.at weed.at; do
      mv readmsg/tests/*-$f readmsg/tests/$f
    done
    # Disable comsat tests that fail without tty in the sandbox.
    tty -s || echo > comsat/tests/testsuite.at
    # Disable lmtp tests that require root spool.
    echo > maidag/tests/lmtp.at
    # Disable mda tests that require /etc/passwd to contain root.
    grep -qo '^root:' /etc/passwd || echo > maidag/tests/mda.at
    # Provide libraries for mhn.
    export LD_LIBRARY_PATH=$(pwd)/lib/.libs
  '';
  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

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
