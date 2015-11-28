{ stdenv, fetchurl, openssl, gmp, zlib, iproute, nettools }:

stdenv.mkDerivation rec {
  name = "gvpe-${version}";
  version = "2.25";

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/gvpe/gvpe-${version}.tar.gz";
    sha256 = "1gsipcysvsk80gvyn9jnk9g0xg4ng9yd5zp066jnmpgs52d2vhvk";
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
