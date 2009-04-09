args: with args;
stdenv.mkDerivation {
  name = "OpenVPN-2.1_rc15";

  src = fetchurl {
    url = http://openvpn.net/release/openvpn-2.1_rc15.tar.gz;
    sha256 = "198k5lbw0bnx67hgflzlzncmdnww0wa7fll0kkirmckav93y7kv6";
  };

  buildInputs = [ iproute lzo openssl];

  meta = { 
      description="OpenVPN is a robust and highly flexible tunneling application compatible with many OSes.";
      homepage="http://openvpn.net/";
      license = "GPLv2";
  };
}
