{stdenv, fetchurl, fetchpatch, pkgconfig, libbsd}:

stdenv.mkDerivation rec {
  version = "1.187";
  deb-version = "${version}-1";
  name = "netcat-openbsd-${version}";

  srcs = [
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${version}.orig.tar.gz";
      sha256 = "0sxsxl7n7hnxz931jqsp86cdwiq2lm4h3w0i2a67935pki924gxw";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/n/netcat-openbsd/netcat-openbsd_${deb-version}.debian.tar.xz";
      sha256 = "0jwbdis6avxdjzg8bcab1bdz296rkzzkdlv50fr3q0277fxjs49q";
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

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/proj/musl.git/plain/net-analyzer/openbsd-netcat/files/openbsd-netcat-1.105-b64_ntop.patch?id=4a5864922232c7df550c21f2a7b77fe6f8ffc6d6";
      sha256 = "1cgqb6fxas5yiwf26hq57v627hhmcskl5j6rx30090ha2ksjqyvr";
    })
  ];

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
