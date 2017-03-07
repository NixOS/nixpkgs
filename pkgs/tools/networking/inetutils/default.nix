{ stdenv, fetchurl, ncurses, perl }:

stdenv.mkDerivation rec {
  name = "inetutils-1.9.4";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "05n65k4ixl85dc6rxc51b1b732gnmm8xnqi424dy9f1nz7ppb3xy";
  };

  buildInputs = [ ncurses /* for `talk' */ perl /* for `whois' */ ];

  configureFlags = "--with-ncurses-include-dir=${ncurses.dev}/include";

  # Test fails with "UNIX socket name too long", probably because our
  # $TMPDIR is too long.
  #doCheck = true;

  postInstall = ''
    # XXX: These programs are normally installed setuid but since it
    # fails, they end up being non-executable, hence this hack.
    chmod +x $out/bin/{ping,ping6,rcp,rlogin,rsh,traceroute}
  '';

  meta = {
    description = "Collection of common network programs";

    longDescription =
      '' The GNU network utilities suite provides the
         following tools: ftp(d), hostname, ifconfig, inetd, logger, ping, rcp,
         rexec(d), rlogin(d), rsh(d), syslogd, talk(d), telnet(d), tftp(d),
         traceroute, uucpd, and whois.
      '';

    homepage = http://www.gnu.org/software/inetutils/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
