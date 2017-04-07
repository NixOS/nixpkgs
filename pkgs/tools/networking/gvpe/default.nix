{ stdenv, fetchurl, openssl, gmp, zlib, iproute, nettools }:

stdenv.mkDerivation rec {
  name = "gvpe-${version}";
  version = "3.0";

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/gvpe/gvpe-${version}.tar.gz";
    sha256 = "1v61mj25iyd91z0ir7cmradkkcm1ffbk52c96v293ibsvjs2s2hf";
  };

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

  meta = {
    description = "A protected multinode virtual network";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux ++ freebsd;
  };
}
