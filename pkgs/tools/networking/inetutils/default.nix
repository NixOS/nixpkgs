{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "inetutils-1.7";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "09v9nycqpc3j7bsi5aj4hm8gxw1xgxr4lz14brnzv0i80qqxjb7p";
  };

  buildInputs = [ ncurses /* for `talk' */ ];

  configureFlags = "--with-ncurses-include-dir=${ncurses}/include";

  doCheck = true;

  postInstall = ''
    # XXX: These programs are normally installed setuid but since it
    # fails, they end up being non-executable, hence this hack.
    chmod +x $out/bin/{ping,ping6,rcp,rlogin,rsh}
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
