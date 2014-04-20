{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "inetutils-1.9.2";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "04wrm0v7l4890mmbaawd6wjwdv08bkglgqhpz0q4dkb0l50fl8q4";
  };

  buildInputs = [ ncurses /* for `talk' */ ];

  configureFlags = "--with-ncurses-include-dir=${ncurses}/include";

  preConfigure = ''
     # Fix for building on Glibc 2.16.  Won't be needed once the
     # gnulib in inetutils is updated.
     sed -i '/gets is a security hole/d' lib/stdio.in.h
  '';

  # Test fails with "UNIX socket name too long", probably because our
  # $TMPDIR is too long.
  #doCheck = true;

  postInstall = ''
    # XXX: These programs are normally installed setuid but since it
    # fails, they end up being non-executable, hence this hack.
    chmod +x $out/bin/{ping,ping6,rcp,rlogin,rsh,traceroute}
  '';

  meta = {
    description = "GNU Inetutils, a collection of common network programs";

    longDescription =
      '' The GNU network utilities suite provides the
         following tools: ftp(d), hostname, ifconfig, inetd, logger, ping, rcp,
         rexec(d), rlogin(d), rsh(d), syslogd, talk(d), telnet(d), tftp(d),
         traceroute, uucpd, and whois.
      '';

    homepage = http://www.gnu.org/software/inetutils/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
