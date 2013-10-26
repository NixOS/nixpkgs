{stdenv, fetchurl, pkgconfig, libbsd}:

stdenv.mkDerivation rec {
  name = "netcat-openbsd-1.105";
  version = "1.105";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_1.105.orig.tar.gz";
      md5 = "7e67b22f1ad41a1b7effbb59ff28fca1";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_1.105-7.debian.tar.gz";
      md5 = "e914f8eb7eda5c75c679dd77787ac76b";
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
