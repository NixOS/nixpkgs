{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "telnet-1.2";

  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/ipv6/telnet-bsd-1.2.tar.bz2;
    sha256 = "0cs7ks22dhcn5qfjv2vl6ikhw93x68gg33zdn5f5cxgg81kx5afn";
  };

  buildInputs = [ncurses];

  meta = {
    description = "A client and daemon for the Telnet protocol";
    homepage = ftp://ftp.suse.com/pub/people/kukuk/ipv6/;
    license = "BSD";
    platforms = stdenv.lib.platforms.gnu;
  };
}
