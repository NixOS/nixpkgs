{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "inetutils-1.8";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "1iqihfv54nzjmclivys2dpcyfhavgynj8pp6r44a97jbw2p0nl68";
  };

  buildInputs = [ ncurses /* for `talk' */ ];

  configureFlags = "--with-ncurses-include-dir=${ncurses}/include";

  doCheck = true;

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
