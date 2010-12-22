{stdenv, fetchurl, iproute, lzo, openssl, nettools}:

stdenv.mkDerivation rec {
  name = "openvpn-2.1.4";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "1x9aymbk580zp35b7dhhkn29a4chhxnzrxjfmp948bgqvvjpizk7";
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
