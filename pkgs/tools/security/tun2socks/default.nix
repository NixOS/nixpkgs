{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "tun2socks-${version}";
  version = "1.999.128";

  src = fetchurl {
    url = "http://badvpn.googlecode.com/files/badvpn-${version}.tar.bz2";
    sha1 = "a932f4791ade68cb9e113eced2d5661c9b796bf1";
  };

  buildInputs = [ cmake ];

  cmakeFlags = "-DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1";

  meta = with stdenv.lib; {
    description = "tun2socks is used to 'socksify' TCP (IPv4 and IPv6) connections at the network layer.";
    homepage = http://code.google.com/p/badvpn/wiki/tun2socks;
    platforms = platforms.unix;
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
