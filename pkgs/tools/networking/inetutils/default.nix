{ stdenv, lib, fetchurl, ncurses, perl, help2man }:

stdenv.mkDerivation rec {
  name = "inetutils-1.9.4";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "05n65k4ixl85dc6rxc51b1b732gnmm8xnqi424dy9f1nz7ppb3xy";
  };

  patches = [
    ./whois-Update-Canadian-TLD-server.patch
    ./service-name.patch
  ];

  buildInputs = [ ncurses /* for `talk' */ perl /* for `whois' */ help2man ];

  configureFlags = [ "--with-ncurses-include-dir=${ncurses.dev}/include" ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ # Musl doesn't define rcmd
    "--disable-rcp"
    "--disable-rsh"
    "--disable-rlogin"
    "--disable-rexec"
  ] ++ lib.optional stdenv.isDarwin  "--disable-servers";

  # Test fails with "UNIX socket name too long", probably because our
  # $TMPDIR is too long.
  doCheck = false;

  installFlags = [ "SUIDMODE=" ];

  meta = with lib; {
    description = "Collection of common network programs";

    longDescription =
      '' The GNU network utilities suite provides the
         following tools: ftp(d), hostname, ifconfig, inetd, logger, ping, rcp,
         rexec(d), rlogin(d), rsh(d), syslogd, talk(d), telnet(d), tftp(d),
         traceroute, uucpd, and whois.
      '';

    homepage = https://www.gnu.org/software/inetutils/;
    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
