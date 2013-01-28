{ fetchurl, stdenv, gettext, gdbm, libtool, pam, readline
, ncurses, gnutls, mysql, guile, texinfo, gnum4, dejagnu }:

/* TODO: Add GNU SASL, GNU GSSAPI, and FreeBidi.  */

stdenv.mkDerivation rec {
  name = "mailutils-2.2";

  src = fetchurl {
    url = "mirror://gnu/mailutils/${name}.tar.bz2";
    sha256 = "0szbqa12zqzldqyw97lxqax3ja2adis83i7brdfsxmrfw68iaf65";
  };

  patches = [ ./path-to-cat.patch ./no-gets.patch ];

  buildInputs =
   [ gettext gdbm libtool pam readline ncurses
     gnutls mysql guile texinfo gnum4 ]
   ++ stdenv.lib.optional doCheck dejagnu;

  doCheck = true;

  meta = {
    description = "GNU Mailutils is a rich and powerful protocol-independent mail framework";

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

    licenses = [ "LGPLv3+" /* libraries */  "GPLv3+" /* tools */ ];

    maintainers = [ stdenv.lib.maintainers.ludo ];

    homepage = http://www.gnu.org/software/mailutils/;

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = stdenv.lib.platforms.gnu;
  };
}
