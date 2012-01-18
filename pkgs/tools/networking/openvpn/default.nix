{stdenv, fetchurl, iproute, lzo, openssl, nettools}:

stdenv.mkDerivation rec {
  name = "openvpn-2.2.2";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "005cpvdvh8pvsn3bc96lrznlkcccbz5jqa62hipb58rf1qk8pjjl";
  };

  buildInputs = [ iproute lzo openssl ];

  configureFlags = ''
    --enable-password-save
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
