{ stdenv, fetchurl, openssl, gmp, zlib, iproute, nettools }:

stdenv.mkDerivation rec {
  name = "gvpe-${version}";
  version = "3.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gvpe/gvpe-${version}.tar.gz";
    sha256 = "1v61mj25iyd91z0ir7cmradkkcm1ffbk52c96v293ibsvjs2s2hf";
  };

  patches = [ ./gvpe-3.0-glibc-2.26.patch ];

  buildInputs = [ openssl gmp zlib ];

  configureFlags = [
    "--enable-tcp"
    "--enable-http-proxy"
    "--enable-dns"
    ];

  preBuild = ''
    sed -e 's@"/sbin/ifconfig.*"@"${iproute}/sbin/ip link set $IFNAME address $MAC mtu $MTU"@' -i src/device-linux.C
    sed -e 's@/sbin/ifconfig@${nettools}/sbin/ifconfig@g' -i src/device-*.C
  '';

  meta = with stdenv.lib; {
    description = "A protected multinode virtual network";
    homepage = http://software.schmorp.de/pkg/gvpe.html;
    maintainers = [ maintainers.raskin ];
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2;
  };
}
