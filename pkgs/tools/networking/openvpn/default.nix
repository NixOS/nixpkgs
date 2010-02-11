{stdenv, fetchurl, iproute, lzo, openssl, nettools}:

stdenv.mkDerivation rec {
  name = "openvpn-2.1.1";

  src = fetchurl {
    url = "http://openvpn.net/release/${name}.tar.gz";
    sha256 = "0hj8cdwgdxfsvjxnw4byys3ij719cg9bl9iadcchayzzymx0s653";
  };

  buildInputs = [ iproute lzo openssl ];

  configureFlags = ''
    --with-ifconfig-path=${nettools}/sbin/ifconfig
    --with-iproute-path=${iproute}/sbin/ip
    --with-route-path=${nettools}/sbin/route
  '';

  meta = { 
      description="OpenVPN is a robust and highly flexible tunneling application compatible with many OSes.";
      homepage="http://openvpn.net/";
      license = "GPLv2";
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
  };
}
