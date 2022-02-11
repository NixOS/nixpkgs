{ lib, stdenv, fetchFromGitHub, pkg-config, libpcap, guile, openssl }:

stdenv.mkDerivation rec {
  pname = "junkie";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "rixed";
    repo = "junkie";
    rev = "v${version}";
    sha256 = "0kfdjgch667gfb3qpiadd2dj3fxc7r19nr620gffb1ahca02wq31";
  };
  buildInputs = [ libpcap guile openssl ];
  nativeBuildInputs = [ pkg-config ];
  configureFlags = [
    "GUILELIBDIR=\${out}/share/guile/site"
    "GUILECACHEDIR=\${out}/lib/guile/ccache"
  ];

  meta = {
    description = "Deep packet inspection swiss-army knife";
    homepage = "https://github.com/rixed/junkie";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.rixed ];
    platforms = lib.platforms.unix;
    longDescription = ''
      Junkie is a network sniffer like Tcpdump or Wireshark, but designed to
      be easy to program and extend.

      It comes with several command line tools to demonstrate this:
      - a packet dumper;
      - a nettop tool;
      - a tool listing TLS certificates...
    '';
  };
}
