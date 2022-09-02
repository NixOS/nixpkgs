{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, libpcap, guile, openssl }:

stdenv.mkDerivation rec {
  pname = "junkie";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "rixed";
    repo = "junkie";
    rev = "v${version}";
    sha256 = "0kfdjgch667gfb3qpiadd2dj3fxc7r19nr620gffb1ahca02wq31";
  };
  patches = [
    # Pull upstream patch for -fno-common toolchains:
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/rixed/junkie/commit/52209c5b0c9a09981739ede9701cd73e82a88ea5.patch";
      sha256 = "1qg01jinqn5wr2mz77rzaidnrli35di0k7lnx6kfm7dh7v8kxbrr";
    })
  ];
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
