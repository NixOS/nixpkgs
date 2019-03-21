{ stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  name = "dhcpdump-1.8";

  src = fetchurl {
    url = "http://archive.ubuntu.com/ubuntu/pool/universe/d/dhcpdump/dhcpdump_1.8.orig.tar.gz";
    sha256 = "143iyzkqvhj4dscwqs75jvfr4wvzrs11ck3fqn5p7yv2h50vjpkd";
  };

  buildInputs = [libpcap perl];

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir -pv $out/bin
    cp dhcpdump $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = http://www.mavetju.org/unix/dhcpdump-man.php;
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
