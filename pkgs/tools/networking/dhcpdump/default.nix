{ lib, stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "dhcpdump";
  version = "1.8";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/d/dhcpdump/dhcpdump_${version}.orig.tar.gz";
    sha256 = "143iyzkqvhj4dscwqs75jvfr4wvzrs11ck3fqn5p7yv2h50vjpkd";
  };

  buildInputs = [libpcap perl];

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir -pv $out/bin
    cp dhcpdump $out/bin
  '';

  meta = with lib; {
    description = "A tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = "http://www.mavetju.org/unix/dhcpdump-man.php";
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
