{stdenv, fetchurl, pkgconfig, libbsd}:

stdenv.mkDerivation rec {
  version = "1.130";
  deb-version = "${version}-3";
  name = "netcat-openbsd-${version}";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${version}.orig.tar.gz";
      sha256 = "0nqy14yvclgzs98gv0fwp6jlfpfy2kk367zka648jiqbbl30awpx";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${deb-version}.debian.tar.xz";
      sha256 = "0f9409vjm6v8a7m1zf5sr7wj6v5v8414i5vvxx1r45c11h69hh9a";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libbsd ];

  sourceRoot = name;
  patches = [ "../debian/patches/*.patch" ];

  installPhase = ''
    install -Dm0755 nc $out/bin/nc
    install -Dm0644 nc.1 $out/share/man/man1/nc.1
  '';

  meta = with stdenv.lib; {
    homepage = https://packages.debian.org/netcat-openbsd;
    description = "TCP/IP swiss army knife, OpenBSD variant";
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz ];
  };

}
