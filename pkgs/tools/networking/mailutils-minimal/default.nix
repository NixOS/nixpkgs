{ fetchurl, stdenv, gettext, gdbm, libtool, pam, readline
, ncurses, gnutls, texinfo, gnum4, dejagnu }:

/* TODO: Add GNU SASL, GNU GSSAPI, and FreeBidi.  */

stdenv.mkDerivation rec {
  name = "mailutils-minimal-2.2";

  src = fetchurl {
    url = "mirror://gnu/mailutils/mailutils-2.2.tar.bz2";
    sha256 = "0szbqa12zqzldqyw97lxqax3ja2adis83i7brdfsxmrfw68iaf65";
  };

  configureFlags = ''
     --without-mysql
     --without-guile
     --without-berkeley-db 
     --without-tokyocabinet 
     --without-fribidi 
     --without-postgres 
     --without-obdc 
     --without-ldap 
     --disable-virtual-domains 
     --disable-imap 
     --disable-pop 
     --disable-nntp  
     --disable-mh 
     --disable-maildir 
     --disable-radius
     --disable-build-pop3d 
     --disable-build-imap4d 
     --disable-build-frm 
     --disable-build-maidag 
     --disable-build-sieve 
     --disable-build-guimb 
     --disable-build-messages 
     --disable-build-movemail 
     --disable-build-mimeview 
     --disable-build-mh
     --disable-virtual-domains
     --with-path-sendmail=/var/setuid-wrappers/sendmail
  '';
  
  
  patches = [ ./path-to-cat.patch ./no-gets.patch ];

  buildInputs =
   [ gettext gdbm libtool pam readline ncurses
     gnutls texinfo gnum4 ]
   ++ stdenv.lib.optional doCheck dejagnu;

  # Tests fail since gcc 4.8
  doCheck = false;

  meta = {
    description = "GNU Mailutils, with most options disabled.";

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

      This package is based on mailutils, but with most options disabled.
    '';

    license = [ "LGPLv3+" /* libraries */  "GPLv3+" /* tools */ ];

    maintainers = [ stdenv.lib.maintainers.nathan-gs stdenv.lib.maintainers.ludo ];

    homepage = http://www.gnu.org/software/mailutils/;

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = stdenv.lib.platforms.gnu;
  };
}
