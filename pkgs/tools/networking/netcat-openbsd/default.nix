{stdenv, fetchurl, pkgconfig, libbsd}:

stdenv.mkDerivation rec {
  name = "netcat-openbsd-1.105";
  version = "1.105";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_1.105.orig.tar.gz";
      sha256 = "07i1vcz8ycnfwsvz356rqmim8akfh8yhjzmhc5mqf5hmdkk3yra0";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_1.105-7.debian.tar.gz";
      sha256 = "0qxkhbwcifrps34s5mzzg79cmkvz3f96gphd3pl978pygwr5krzf";
    })
  ];

  buildInputs = [ pkgconfig libbsd ];
  sourceRoot = name;
  patches = [ "../debian/patches/*.patch" ];

  installPhase = ''
    install -Dm0755 nc $out/bin/nc
  '';

  meta = {
    homepage = "http://packages.debian.org/netcat-openbsd";
    description = "TCP/IP swiss army knife. OpenBSD variant.";
    platforms = stdenv.lib.platforms.linux;
  };

}
