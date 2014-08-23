{ stdenv, fetchurl, libpcap }:

stdenv.mkDerivation rec {
  name = "arp-scan-1.9";

  src = fetchurl {
    url = "http://www.nta-monitor.com/files/arp-scan/${name}.tar.gz";
    sha256 = "14nqjzbmnlx2nac7lwa93y5m5iqk3layakyxyvfmvs283k3qm46f";
  };

  buildInputs = [ libpcap ];

  meta = with stdenv.lib; {
    description = "ARP scanning and fingerprinting tool";
    longDescription = ''
      Arp-scan is a command-line tool that uses the ARP protocol to discover
      and fingerprint IP hosts on the local network.
    '';
    homepage = http://www.nta-monitor.com/tools-resources/security-tools/arp-scan;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
