{stdenv, fetchurl, pkgconfig, libbsd}:

stdenv.mkDerivation rec {
  version = "1.190";
  deb-version = "${version}-1";
  name = "netcat-openbsd-${version}";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${version}.orig.tar.gz";
      sha256 = "0dp571m42zc7wvb9bf4hz5a08rcc5fknf0gdp98yq19c754c9k38";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${deb-version}.debian.tar.xz";
      sha256 = "0plgrri85sghzn499jzd9d3h7w61ksqj0amkwmcah8dmfkp7jrgv";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libbsd ];

  sourceRoot = name;

  prePatch = ''
    for i in $(cat ../debian/patches/series); do
      patch -p1 < "../debian/patches/$i"
    done
  '';

  installPhase = ''
    runHook preInstall
    install -Dm0755 nc $out/bin/nc
    install -Dm0644 nc.1 $out/share/man/man1/nc.1
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://packages.debian.org/netcat-openbsd;
    description = "TCP/IP swiss army knife, OpenBSD variant";
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz ];
  };

}
