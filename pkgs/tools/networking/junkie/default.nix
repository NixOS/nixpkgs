{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libpcap, guile_2_2, openssl }:

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

  # IP_DONTFRAG is defined on macOS from Big Sur
  postPatch = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    sed -i '10i#undef IP_DONTFRAG' include/junkie/proto/ip.h
  '';

  buildInputs = [ libpcap guile_2_2 openssl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];
  configureFlags = [
    "GUILELIBDIR=\${out}/${guile_2_2.siteDir}"
    "GUILECACHEDIR=\${out}/${guile_2_2.siteCcacheDir}"
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
